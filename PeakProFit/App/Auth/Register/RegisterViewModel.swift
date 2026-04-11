//
//  RegisterViewModel.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 26/3/26.
//

import Foundation
import Observation
import FirebaseAuth

@MainActor
@Observable
final class RegisterViewModel {
    var name = ""
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
    
    func validateEmail(){
        emailError = Validation.validateEmail(email)
    }
    
    func validatePassword(){
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

    func register() async {
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
            let result = try await Auth.auth().createUser(withEmail: email, password: password)

            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedName.isEmpty {
                let changeRequest = result.user.createProfileChangeRequest()
                changeRequest.displayName = trimmedName
                try await changeRequest.commitChanges()
            }

            formMessage = "Signed up successfully."
            isSuccessMessage = true
        } catch {
            formMessage = error.localizedDescription
            isSuccessMessage = false
        }
    }
}
