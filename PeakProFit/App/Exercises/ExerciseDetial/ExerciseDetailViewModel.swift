//
//  ExerciseDetialViewModel.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import Foundation
import Observation

@Observable
final class ExerciseDetailViewModel {
    let exerciseID: String

    var exercise: ExerciseDetailEntity?
    var exerciseImageURL: URL?
    var isLoading = false
    var errorMessage: String?

    private let dataSource: any DataSourceProtocol

    init(exerciseID: String) {
        self.exerciseID = exerciseID
        self.dataSource = AppContainer.shared.exercisesDataSource
    }

    func loadExercise() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            exercise = try await dataSource.getExerciseDetail(exerciseID: exerciseID)
            await loadExerciseImageURL()
        } catch is CancellationError {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadExerciseImageURL(resolution: Int = 360) async {
        do {
            exerciseImageURL = try await dataSource.getExerciseImageURL(
                exerciseID: exerciseID,
                resolution: resolution
            )
        } catch {
            print("[ExerciseDetailViewModel] Image load error for \(exerciseID): \(error.localizedDescription)")
            exerciseImageURL = nil
        }
    }
}
