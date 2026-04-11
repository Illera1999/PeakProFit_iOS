import Foundation
import Observation
import FirebaseAuth

@MainActor
@Observable
final class ForgotPasswordViewModel {
    var email = ""
    var emailError: String?
    var formMessage: String?
    var isSuccessMessage = false
    var isLoading = false

    var isFormValid: Bool {
        emailError == nil && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func validateEmail() {
        emailError = Validation.validateEmail(email)
    }

    func clearMessagesOnEdit() {
        formMessage = nil
        isSuccessMessage = false
    }

    func sendResetEmail() async {
        guard !isLoading else { return }
        validateEmail()

        guard isFormValid else {
            formMessage = "Please review your email."
            isSuccessMessage = false
            return
        }

        isLoading = true
        formMessage = nil
        defer { isLoading = false }

        do {
            try await Auth.auth().sendPasswordReset(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines))
            formMessage = "We sent you an email to reset your password."
            isSuccessMessage = true
        } catch {
            formMessage = AuthErrorMapper.passwordResetMessage(from: error)
            isSuccessMessage = false
        }
    }
}
