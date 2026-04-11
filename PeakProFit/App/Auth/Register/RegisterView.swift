//
//  RegisterView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 26/3/26.
//

import SwiftUI

struct RegisterView: View {
    @State private var viewModel = RegisterViewModel()
    

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                TextFieldView(
                    label: "Name",
                    text: $viewModel.name,
                )
                TextFieldView(
                    label: "Email",
                    text: $viewModel.email,
                    errorMessage: viewModel.emailError
                ).onChange(of: viewModel.email){
                    viewModel.clearMessagesOnEdit()
                    viewModel.validateEmail()
                }
                TextFieldView(
                    label: "Password",
                    isSecureField: true,
                    text: $viewModel.password,
                    errorMessage: viewModel.passwordError
                ).onChange(of: viewModel.password){
                    viewModel.clearMessagesOnEdit()
                    viewModel.validatePassword()
                }

                VStack(spacing: 12){
                    if let message = viewModel.formMessage {
                        Text(message)
                            .styleSubtitle()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 42)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            Button {
                Task { await viewModel.register() }
            } label: {
                HStack {
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Sign up")
                            .font(.custom("Lexend-SemiBold", size: 18))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .styleAuthPrimaryButton()
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color(.systemGray6))
        }
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

#Preview {
    SignUpPage()
}
