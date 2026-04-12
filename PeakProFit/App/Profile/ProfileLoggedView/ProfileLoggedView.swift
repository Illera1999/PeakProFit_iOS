//
//  ProfileLoggedView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

//
//  ProfilePage.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//
import SwiftUI
import FirebaseAuth

struct ProfileLoggedView: View {
    
    @State private var session = SessionViewModel.shared
    @State private var isShowingDeleteAccountAlert = false
    @State private var isDeletingAccount = false

    let currectUser: User
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Logged in as:")
                .styleSubtitle()
            Text(currectUser.email ?? "Email not available")
                .styleHeader()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            NavigationLink {
                SavedExercisesPage()
            } label: {
                HStack {
                    Text("Saved exercises")
                        .styleSubtitle()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color("ColorTextSecondary"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                )
            }
            .buttonStyle(.plain)

            Spacer()

            Button("Delete account") {
                isShowingDeleteAccountAlert = true
            }
            .font(.custom("Lexend-Medium", size: 14))
            .foregroundStyle(.red)
            .buttonStyle(.plain)
            .disabled(isDeletingAccount)

            Button("Log out") {
                session.signOut()
            }
            .styleDangerActionButton()
            .disabled(isDeletingAccount)
            .padding(.bottom, 24)
        }
        .alert("Delete account?", isPresented: $isShowingDeleteAccountAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task { await deleteAccount() }
            }
        } message: {
            Text("This action is permanent and cannot be undone.")
        }
    }

    private func deleteAccount() async {
        guard !isDeletingAccount else { return }
        isDeletingAccount = true
        defer { isDeletingAccount = false }

        do {
            try await session.deleteAccount()
            SnackbarCenter.shared.show(
                message: "Your account has been deleted.",
                style: .success
            )
        } catch {
            SnackbarCenter.shared.show(
                message: AuthErrorMapper.deleteAccountMessage(from: error),
                style: .error
            )
        }
    }
}

#Preview {
    ProfilePage()
}
