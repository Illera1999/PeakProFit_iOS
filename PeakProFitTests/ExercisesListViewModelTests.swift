import XCTest
@testable import PeakProFit

@MainActor
final class ExercisesListViewModelTests: XCTestCase {
    func testLoadExercisesSuccessAndDifficultyFilter() async {
        let stubItems = [
            ExerciseEntity(id: "1", name: "Bench", targetMuscles: ["chest"], equipments: ["barbell"], difficulty: "beginner"),
            ExerciseEntity(id: "2", name: "Squat", targetMuscles: ["legs"], equipments: ["barbell"], difficulty: "intermediate")
        ]
        let dataSource = DataSourceMock(exercisesResult: .success(stubItems))
        let sut = ExercisesListViewModel(dataSource: dataSource)

        await sut.loadExercises()

        XCTAssertEqual(sut.allExercises.count, 2)
        XCTAssertEqual(sut.exercises.count, 2)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.availableDifficulties.sorted(), ["beginner", "intermediate"])

        sut.toggleDifficulty("beginner")
        XCTAssertEqual(sut.exercises.map(\.id), ["1"])

        sut.clearDifficultyFilter()
        XCTAssertEqual(sut.exercises.count, 2)
    }

    func testLoadExercisesErrorSetsMessage() async {
        let dataSource = DataSourceMock(exercisesResult: .failure(MockError.generic))
        let sut = ExercisesListViewModel(dataSource: dataSource)

        await sut.loadExercises()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.exercises.isEmpty)
    }
}

private enum MockError: Error {
    case generic
}

private struct DataSourceMock: DataSourceProtocol {
    let exercisesResult: Result<[ExerciseEntity], Error>

    func getExercises() async throws -> [ExerciseEntity] {
        try exercisesResult.get()
    }

    func getExerciseDetail(exerciseID: String) async throws -> ExerciseDetailEntity {
        ExerciseDetailEntity(
            id: exerciseID,
            name: "name",
            equipments: [],
            secondaryMuscles: [],
            instructions: [],
            difficulty: nil
        )
    }

    func getExerciseImageURL(exerciseID: String, resolution: Int) async throws -> URL? {
        nil
    }
}
