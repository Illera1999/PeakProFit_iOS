//
//  ExercisesListViewModel.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ExercisesListViewModel {
    var allExercises: [ExerciseEntity] = []
    var exercises: [ExerciseEntity] = []
    var selectedDifficulty: String?
    var isLoading = false
    var errorMessage: String?

    private let dataSource: any DataSourceProtocol

    init(dataSource: any DataSourceProtocol) {
        self.dataSource = dataSource
    }

    convenience init() {
        self.init(dataSource: AppContainer.shared.exercisesDataSource)
    }

    var availableDifficulties: [String] {
        let difficulties = allExercises.compactMap { exercise -> String? in
            guard let difficulty = exercise.difficulty?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !difficulty.isEmpty else {
                return nil
            }
            return difficulty.lowercased()
        }
        return Array(Set(difficulties)).sorted()
    }

    func toggleDifficulty(_ difficulty: String) {
        if selectedDifficulty == difficulty {
            selectedDifficulty = nil
        } else {
            selectedDifficulty = difficulty
        }
        applyFilters()
    }

    func clearDifficultyFilter() {
        selectedDifficulty = nil
        applyFilters()
    }

    func loadExercises() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            allExercises = []
            exercises = []
            allExercises = try await dataSource.getExercises()
            applyFilters()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func applyFilters() {
        guard let selectedDifficulty else {
            exercises = allExercises
            return
        }

        exercises = allExercises.filter { exercise in
            exercise.difficulty?.lowercased() == selectedDifficulty.lowercased()
        }
    }
}
