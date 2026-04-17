import CoreData
import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

@MainActor
final class FavoritesStore {
    static let shared = FavoritesStore()
    private static let maxNoteLength = 124

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

    func removeAllFavorites(userId: String) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteExercise")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        let objects = try context.fetch(request)

        for object in objects {
            context.delete(object)
        }

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

    func updatePersonalNote(userId: String, exerciseId: String, note: String) throws {
        guard let object = favoriteObject(userId: userId, exerciseId: exerciseId) else { return }
        let safeNote = String(note.prefix(Self.maxNoteLength))
        object.setValue(safeNote, forKey: "personalNote")

        if context.hasChanges {
            try context.save()
            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        }
    }

    func fetchPersonalNote(userId: String, exerciseId: String) -> String {
        guard let object = favoriteObject(userId: userId, exerciseId: exerciseId) else { return "" }
        return (object.value(forKey: "personalNote") as? String) ?? ""
    }

    func updateStoredExerciseInfo(
        userId: String,
        exerciseId: String,
        instructions: [String],
        difficulty: String?
    ) throws {
        guard let object = favoriteObject(userId: userId, exerciseId: exerciseId) else { return }
        object.setValue(serialize(instructions), forKey: "instructionsRaw")

        if let normalizedDifficulty = normalizeText(difficulty) {
            object.setValue(normalizedDifficulty, forKey: "difficulty")
        }

        if context.hasChanges {
            try context.save()
        }
    }

    func fetchStoredInstructions(userId: String, exerciseId: String) -> [String] {
        guard let object = favoriteObject(userId: userId, exerciseId: exerciseId) else { return [] }
        let instructionsRaw = object.value(forKey: "instructionsRaw") as? String
        return deserialize(instructionsRaw)
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
        object.setValue(normalizeText(exercise.difficulty), forKey: "difficulty")
        object.setValue(Date(), forKey: "createdAt")
    }

    private func normalizeText(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
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
        let difficulty = normalizeText(object.value(forKey: "difficulty") as? String)

        return ExerciseEntity(
            id: id,
            name: name,
            targetMuscles: deserialize(targetMusclesRaw),
            equipments: deserialize(equipmentsRaw),
            difficulty: difficulty
        )
    }
}
