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
            Button("Log out") {
                session.signOut()
            }
            .styleDangerActionButton()
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    ProfilePage()
}
