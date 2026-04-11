//
//  ExerciseDBRemoteDataSource.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 15/3/26.
//

import Foundation


final class DataSourceImplement: DataSourceProtocol {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getExercises() async throws -> [ExerciseEntity] {
        let response: [ExerciseDto] = try await apiClient.get("/exercises")
        return response.map(ExerciseMapper.toEntity)
    }

    func getExerciseDetail(exerciseID: String) async throws -> ExerciseDetailEntity {
        let safeExerciseID = exerciseID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? exerciseID
        let response: ExerciseDetailDto = try await apiClient.get("/exercises/exercise/\(safeExerciseID)")
        return ExerciseDetailMapper.toEntity(response)
    }

    func getExerciseImageURL(exerciseID: String, resolution: Int = 360) async throws -> URL? {
        let safeExerciseID = exerciseID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? exerciseID
        return try await apiClient.getData(
            "/image?exerciseId=\(safeExerciseID)&resolution=\(resolution)",
            cacheFileName: "\(safeExerciseID)-\(resolution).gif"
        )
    }
}
