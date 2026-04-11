//
//  TextFieldView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 28/3/26.
//
import SwiftUI

struct TextFieldView: View {
    let label: String
    var placeholder: String = ""
    var isSecureField: Bool = false
    @Binding var text: String
    var errorMessage: String? = nil

    @State private var isPasswordVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).styleHeader()

            HStack(spacing: 10) {
                Group {
                    if isSecureField && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }

                if isSecureField {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.plain)
                }

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(errorMessage == nil ? Color("ColorTextSecondary").opacity(0.35) : .red, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 3)

            if let errorMessage {
                Text(errorMessage).styleSubtitle()
            }
        }
    }
}


#Preview {
    @Previewable @State var text: String = ""
    TextFieldView(label: "Hola, \(text)", text: $text)
    .padding(24)
}
