//
//  MainTabView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ExercisesPage()
                .tabItem {
                    Label("Exercises", systemImage: "figure.strengthtraining.traditional")
                }

            NavigationStack {
                ProfilePage()
            }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(Color("ColorBrandGreen"))
        .toolbarBackground(Color("ColorSurface"), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    MainTabView()
}
