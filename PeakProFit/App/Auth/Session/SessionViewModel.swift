//
//  SessionViewModel.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//
import Foundation
import Observation
import FirebaseAuth

@MainActor
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
            Task { @MainActor in
                guard let self else { return }
                self.currentUser = user
                self.isAuthenticated = (user != nil)
                if user != nil {
                    self.isGuestMode = false
                }
                self.isLoading = false
            }
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

    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(
                domain: "SessionViewModel",
                code: AuthErrorCode.userNotFound.rawValue,
                userInfo: [NSLocalizedDescriptionKey: "No authenticated user."]
            )
        }

        let userId = user.uid
        try await user.delete()
        do {
            try FavoritesStore.shared.removeAllFavorites(userId: userId)
        } catch {
            print("Local favorites cleanup error: \(error.localizedDescription)")
        }
        isGuestMode = false
    }
}
