//
//  LogInViewModel.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

import Foundation
import Observation
import FirebaseAuth

@MainActor
@Observable
final class LogInViewModel {
    var email = ""
    var password = ""

    var emailError: String?
    var passwordError: String?
    var formMessage: String?
    var isSuccessMessage = false

    var isLoading = false

    var isFormValid: Bool {
        emailError == nil &&
        passwordError == nil &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }

    func validateEmail() {
        emailError = Validation.validateEmail(email)
    }

    func validatePassword() {
        passwordError = Validation.validatePassword(password)
    }

    func validateForm() {
        validateEmail()
        validatePassword()
    }

    func clearMessagesOnEdit() {
        formMessage = nil
        isSuccessMessage = false
    }

    func logIn() async {
        guard !isLoading else { return }

        validateForm()
        guard isFormValid else {
            formMessage = "Please review your fields."
            isSuccessMessage = false
            return
        }

        isLoading = true
        formMessage = nil
        defer { isLoading = false }

        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            formMessage = "Logged in successfully."
            isSuccessMessage = true
        } catch {
            formMessage = AuthErrorMapper.loginMessage(from: error)
            isSuccessMessage = false
        }
    }
}
