//
//  AuthErrorMapper.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

import Foundation
import FirebaseAuth

enum AuthErrorMapper {
    static func loginMessage(from error: Error) -> String {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else {
            return "Unable to log in. Please try again."
        }

        switch code {
        case .wrongPassword:
            return "Incorrect password."
        case .userNotFound:
            return "No account found with this email."
        case .invalidEmail:
            return "Invalid email format."
        case .invalidCredential:
            return "Incorrect email or password."
        case .userDisabled:
            return "This account has been disabled."
        case .tooManyRequests:
            return "Too many attempts. Please try again later."
        case .networkError:
            return "Network error. Check your connection and try again."
        default:
            return "Unable to log in. Please try again."
        }
    }

    static func passwordResetMessage(from error: Error) -> String {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else {
            return "Unable to send reset email. Please try again."
        }

        switch code {
        case .invalidEmail:
            return "Invalid email format."
        case .userNotFound:
            return "No account found with this email."
        case .userDisabled:
            return "This account has been disabled."
        case .tooManyRequests:
            return "Too many attempts. Please try again later."
        case .networkError:
            return "Network error. Check your connection and try again."
        default:
            return "Unable to send reset email. Please try again."
        }
    }

    static func deleteAccountMessage(from error: Error) -> String {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else {
            return "Unable to delete account. Please try again."
        }

        switch code {
        case .requiresRecentLogin:
            return "For security, please log in again before deleting your account."
        case .networkError:
            return "Network error. Check your connection and try again."
        case .userNotFound:
            return "Account not found."
        case .tooManyRequests:
            return "Too many attempts. Please try again later."
        default:
            return "Unable to delete account. Please try again."
        }
    }
}
