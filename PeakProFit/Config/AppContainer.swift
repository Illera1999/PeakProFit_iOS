//
//  AppContainer.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

final class AppContainer {
    static let shared = AppContainer()

    let exercisesDataSource: any DataSourceProtocol

    private init() {
        let apiClient = APIClient(baseURL: AppConfig.apiBaseURL)
        // En caso de que quiera cambiar la implementación cambio [DataSourceImplement]
        self.exercisesDataSource = DataSourceImplement(apiClient: apiClient)
    }
}
