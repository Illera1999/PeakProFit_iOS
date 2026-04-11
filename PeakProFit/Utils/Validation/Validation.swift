//
//  Validation.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 28/3/26.
//

import Foundation

enum Validation {
    static func validateEmail(_ email: String) -> String? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "An email address is required." }

        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: trimmed)
        return isValid ? nil : "Invalid email address."
    }

    static func validatePassword(_ password: String) -> String? {
        guard !password.isEmpty else { return "A password is required." }
        guard !password.contains(" ") else { return "The password must not contain spaces." }
        guard password.count >= 8 else { return "At least 8 characters." }
        guard password.rangeOfCharacter(from: .decimalDigits) != nil else {
            return "You must include at least one number."
        }
        return nil
    }
}
