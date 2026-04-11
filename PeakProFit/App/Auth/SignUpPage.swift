//
//  RegisterPage.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 28/3/26.
//

import SwiftUI

struct SignUpPage: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: "Sign Up",
                showsBackButton: true)
            RegisterView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SignUpPage()
}
