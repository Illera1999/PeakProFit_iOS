import XCTest
@testable import PeakProFit

final class MapperTests: XCTestCase {
    func testExerciseMapperMapsExpectedFields() {
        let dto = ExerciseDto(
            id: "e1",
            name: "bench press",
            bodyPart: "chest",
            target: "pectorals",
            equipment: "barbell",
            secondaryMuscles: ["triceps"],
            instructions: ["step 1"],
            description: nil,
            difficulty: "beginner",
            category: nil
        )

        let entity = ExerciseMapper.toEntity(dto)

        XCTAssertEqual(entity.id, "e1")
        XCTAssertEqual(entity.name, "bench press")
        XCTAssertEqual(entity.targetMuscles, ["pectorals"])
        XCTAssertEqual(entity.equipments, ["barbell"])
        XCTAssertEqual(entity.difficulty, "beginner")
    }

    func testExerciseDetailMapperMapsExpectedFields() {
        let dto = ExerciseDetailDto(
            id: "e2",
            name: "deadlift",
            bodyPart: "back",
            target: "spine",
            equipment: "barbell",
            secondaryMuscles: ["hamstrings"],
            instructions: ["setup", "pull"],
            description: nil,
            difficulty: "intermediate",
            category: "strength"
        )

        let entity = ExerciseDetailMapper.toEntity(dto)

        XCTAssertEqual(entity.id, "e2")
        XCTAssertEqual(entity.name, "deadlift")
        XCTAssertEqual(entity.equipments, ["barbell"])
        XCTAssertEqual(entity.secondaryMuscles, ["hamstrings"])
        XCTAssertEqual(entity.instructions, ["setup", "pull"])
        XCTAssertEqual(entity.difficulty, "intermediate")
    }
}
