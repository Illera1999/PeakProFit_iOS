//
//  SessionViewModel.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//
import Foundation
import Observation
import FirebaseAuth

@Observable
final class SessionViewModel {
    static let shared = SessionViewModel()

    var currentUser: User?
    var isAuthenticated = false
    var isGuestMode = false
    var isLoading = true
    
    var canAccessApp: Bool {
        isAuthenticated || isGuestMode
    }

    private var handle: AuthStateDidChangeListenerHandle?

    private init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            self.currentUser = user
            self.isAuthenticated = (user != nil)
            if user != nil {
                self.isGuestMode = false
            }
            self.isLoading = false
        }
    }
    
    func continueAsGuest() {
        isGuestMode = true
    }

    func exitGuestMode() {
        isGuestMode = false
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
        isGuestMode = false
    }

    deinit {
        if let handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
