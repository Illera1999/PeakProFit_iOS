//
//  ExercisesListViewModel.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import Foundation
import Observation

@Observable
final class ExercisesListViewModel {
    var exercises: [ExerciseEntity] = []
    var isLoading = false
    var errorMessage: String?

    private let dataSource: any DataSourceProtocol

    init() {
        self.dataSource = AppContainer.shared.exercisesDataSource
    }

    func loadExercises() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            exercises = []
            exercises = try await dataSource.getExercises()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
