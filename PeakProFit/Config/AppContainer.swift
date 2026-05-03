//
//  AppContainer.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

final class AppContainer {
    static let shared = AppContainer()

    let exercisesDataSource: any DataSourceProtocol

    init(exercisesDataSource: (any DataSourceProtocol)? = nil) {
        if let exercisesDataSource {
            self.exercisesDataSource = exercisesDataSource
            return
        }
        let apiClient = APIClient(baseURL: AppConfig.apiBaseURL)
        self.exercisesDataSource = DataSourceImplement(apiClient: apiClient)
    }
}
