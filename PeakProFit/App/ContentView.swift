//
//  ContentView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 11/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var session = SessionViewModel.shared

    var body: some View {
        if session.isLoading {
            ProgressView()
        } else if session.canAccessApp {
            MainTabView()
        } else {
            LoginPage()
        }
    }
}
