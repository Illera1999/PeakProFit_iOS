//
//  PeakProFitApp.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 11/3/26.
//

import SwiftUI
import CoreData
import FirebaseCore

@main
struct PeakProFitApp: App {
    private let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
            )
            .withSnackbar()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
