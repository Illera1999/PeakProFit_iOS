import CoreData
import XCTest
@testable import PeakProFit

@MainActor
final class FavoritesStoreTests: XCTestCase {
    func testSaveFetchUpdateAndRemoveFavorite() throws {
        let context = try makeInMemoryContext()
        let sut = FavoritesStore(context: context)
        let exercise = ExerciseEntity(
            id: "bench-1",
            name: "Bench Press",
            targetMuscles: ["chest"],
            equipments: ["barbell"],
            difficulty: "beginner"
        )

        try sut.saveFavorite(exercise: exercise, userId: "u1")
        XCTAssertTrue(sut.isFavorite(userId: "u1", exerciseId: "bench-1"))

        var favorites = try sut.fetchFavorites(userId: "u1")
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.id, "bench-1")

        try sut.updatePersonalNote(userId: "u1", exerciseId: "bench-1", note: "Keep elbows tucked")
        XCTAssertEqual(sut.fetchPersonalNote(userId: "u1", exerciseId: "bench-1"), "Keep elbows tucked")

        try sut.updateStoredExerciseInfo(
            userId: "u1",
            exerciseId: "bench-1",
            instructions: ["setup", "press"],
            difficulty: "intermediate"
        )
        XCTAssertEqual(sut.fetchStoredInstructions(userId: "u1", exerciseId: "bench-1"), ["setup", "press"])

        try sut.removeFavorite(userId: "u1", exerciseId: "bench-1")
        favorites = try sut.fetchFavorites(userId: "u1")
        XCTAssertTrue(favorites.isEmpty)
    }

    private func makeInMemoryContext() throws -> NSManagedObjectContext {
        guard
            let modelURL = Bundle(for: FavoriteExercise.self)
                .url(forResource: "PeakProFit", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            throw NSError(domain: "FavoritesStoreTests", code: 1, userInfo: nil)
        }

        let container = NSPersistentContainer(name: "PeakProFit", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        if let loadError { throw loadError }
        return container.viewContext
    }
}
