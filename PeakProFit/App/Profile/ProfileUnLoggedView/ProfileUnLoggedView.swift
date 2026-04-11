//
//  ProfileUnLoggedView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 31/3/26.
//

import SwiftUI

struct ProfileUnLoggedView: View {
    @State private var session = SessionViewModel.shared

    var body: some View {
        VStack(spacing: 12) {
            Text("You are not logged in.")
                .styleSubtitle()

            Button("Go to login") {
                session.exitGuestMode()
            }
            .font(.custom("Lexend-Medium", size: 14))
            .foregroundStyle(.blue)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ProfileUnLoggedView()
}

