//
//  DataSourceProtocol.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 15/3/26.
//

import Foundation

protocol DataSourceProtocol {
    func getExercises() async throws -> [ExerciseEntity]
    func getExerciseDetail(exerciseID: String) async throws -> ExerciseDetailEntity
    func getExerciseImageURL(exerciseID: String, resolution: Int) async throws -> URL?
}
