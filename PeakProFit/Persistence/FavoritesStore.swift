import CoreData
import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

@MainActor
final class FavoritesStore {
    static let shared = FavoritesStore()

    private let context: NSManagedObjectContext

    private init(context: NSManagedObjectContext? = nil) {
        let resolvedContext = context ?? PersistenceController.shared.container.viewContext
        self.context = resolvedContext
    }

    func isFavorite(userId: String, exerciseId: String) -> Bool {
        favoriteObject(userId: userId, exerciseId: exerciseId) != nil
    }

    func saveFavorite(exercise: ExerciseEntity, userId: String) throws {
        if let existing = favoriteObject(userId: userId, exerciseId: exercise.id) {
            update(existing: existing, with: exercise, userId: userId)
        } else {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "FavoriteExercise", into: context)
            update(existing: entity, with: exercise, userId: userId)
        }

        if context.hasChanges {
            try context.save()
            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        }
    }

    func removeFavorite(userId: String, exerciseId: String) throws {
        guard let object = favoriteObject(userId: userId, exerciseId: exerciseId) else { return }
        context.delete(object)

        if context.hasChanges {
            try context.save()
            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        }
    }

    func fetchFavorites(userId: String) throws -> [ExerciseEntity] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteExercise")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        let objects = try context.fetch(request)
        return objects.compactMap(mapToExerciseEntity)
    }

    private func favoriteObject(userId: String, exerciseId: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteExercise")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "userId == %@ AND exerciseId == %@", userId, exerciseId)

        do {
            return try context.fetch(request).first
        } catch {
            print("[FavoritesStore] Fetch error: \(error.localizedDescription)")
            return nil
        }
    }

    private func update(existing object: NSManagedObject, with exercise: ExerciseEntity, userId: String) {
        object.setValue(userId, forKey: "userId")
        object.setValue(exercise.id, forKey: "exerciseId")
        object.setValue(exercise.name, forKey: "name")
        object.setValue(serialize(exercise.targetMuscles), forKey: "targetMusclesRaw")
        object.setValue(serialize(exercise.equipments), forKey: "equipmentsRaw")
        object.setValue(Date(), forKey: "createdAt")
    }

    private func serialize(_ array: [String]) -> String {
        guard let data = try? JSONEncoder().encode(array),
              let raw = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return raw
    }

    private func deserialize(_ raw: String?) -> [String] {
        guard let raw,
              let data = raw.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return decoded
    }

    private func mapToExerciseEntity(_ object: NSManagedObject) -> ExerciseEntity? {
        guard let id = object.value(forKey: "exerciseId") as? String,
              let name = object.value(forKey: "name") as? String else {
            return nil
        }

        let targetMusclesRaw = object.value(forKey: "targetMusclesRaw") as? String
        let equipmentsRaw = object.value(forKey: "equipmentsRaw") as? String

        return ExerciseEntity(
            id: id,
            name: name,
            targetMuscles: deserialize(targetMusclesRaw),
            equipments: deserialize(equipmentsRaw)
        )
    }
}
