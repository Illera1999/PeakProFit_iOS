//
//  ProfilePage.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

import SwiftUI
import FirebaseAuth

struct ProfilePage: View {
    @State private var session = SessionViewModel.shared
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Profile")

            VStack(spacing: 16) {
                if session.isAuthenticated, let email = session.currentUser?.email, !email.isEmpty {
                    ProfileLoggedView(currectUser: session.currentUser!)
                } else {
                    ProfileUnLoggedView()
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

#Preview {
    ProfilePage()
}
