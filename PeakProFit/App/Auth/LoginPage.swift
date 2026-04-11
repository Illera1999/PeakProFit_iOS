//
//  LoginPage.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

import SwiftUI

struct LoginPage: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                HeaderView(
                    title: "Log in"
                    )
                LogInView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    LoginPage()
}
