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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(
            )
            .withSnackbar()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
