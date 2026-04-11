import SwiftUI

struct ForgotPasswordPage: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Reset password", showsBackButton: true)
            ForgotPasswordView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordPage()
    }
}
