//
//  LogInView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

import SwiftUI

struct LogInView: View {
    @State private var viewModel = LogInViewModel()
    @State private var session = SessionViewModel.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                TextFieldView(
                    label: "Email",
                    text: $viewModel.email,
                    errorMessage: viewModel.emailError
                )
                .onChange(of: viewModel.email) {
                    viewModel.clearMessagesOnEdit()
                    viewModel.validateEmail()
                }

                TextFieldView(
                    label: "Password",
                    isSecureField: true,
                    text: $viewModel.password,
                    errorMessage: viewModel.passwordError
                )
                .onChange(of: viewModel.password) {
                    viewModel.clearMessagesOnEdit()
                    viewModel.validatePassword()
                }

                HStack(spacing: 0) {
                    Text("If you are not registered click ")
                        .styleSubtitle()
                    NavigationLink("here") {
                        SignUpPage(

                        )
                    }
                    .font(.custom("Lexend-Medium", size: 12))
                    .foregroundStyle(.blue)
                    Text(" to sign up.")
                        .styleSubtitle()
                }
                .frame(maxWidth: .infinity, alignment: .center)

            }
            .padding(.horizontal, 24)
            .padding(.top, 42)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                NavigationLink("Forgot your password?") {
                    ForgotPasswordPage()
                }
                .font(.custom("Lexend-Medium", size: 13))
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity, alignment: .center)

                Button("Continue as guest") {
                    session.continueAsGuest()
                }
                .font(.custom("Lexend-Medium", size: 13))
                .foregroundStyle(.blue)
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .center)

                Button {
                    Task {
                        await viewModel.logIn()
                        if let message = viewModel.formMessage {
                            SnackbarCenter.shared.show(
                                message: message,
                                style: viewModel.isSuccessMessage ? .success : .error
                            )
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Log in")
                                .font(.custom("Lexend-SemiBold", size: 18))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }
                    .styleAuthPrimaryButton()
                }
                .buttonStyle(.plain)
                .disabled(!viewModel.isFormValid || viewModel.isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color(.systemGray6))
        }
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

#Preview {
    LoginPage()
}
