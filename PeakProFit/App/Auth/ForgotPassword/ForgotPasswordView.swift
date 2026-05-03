import SwiftUI

struct ForgotPasswordView: View {
    @State private var viewModel = ForgotPasswordViewModel()
    @Environment(\.dismiss) private var dismiss

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

                if let message = viewModel.formMessage {
                    Text(message)
                        .styleSubtitle()
                        .foregroundStyle(viewModel.isSuccessMessage ? .green : .red)
                        .frame(maxWidth: .infinity, alignment: .center)
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
                Task {
                    await viewModel.sendResetEmail()
                    if viewModel.isSuccessMessage {
                        SnackbarCenter.shared.show(
                            message: "Se ha enviado un correo para el cambio de contraseña.",
                            style: .success
                        )
                        dismiss()
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Send reset email")
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
            .background(Color("ColorAppBackground"))
        }
        .background(Color("ColorAppBackground").ignoresSafeArea())
    }
}

#Preview {
    ForgotPasswordPage()
}
