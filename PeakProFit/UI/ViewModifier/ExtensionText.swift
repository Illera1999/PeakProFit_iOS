//
//  extensionText.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 16/3/26.
//

import SwiftUI

extension Text {
    func stylePageTitle() -> some View {
        self
            .font(.custom("Lexend-SemiBold", size: 30))
            .foregroundStyle(Color.primary)
            .kerning(0) // 0% letter spacing
            .multilineTextAlignment(.center)
    }

    func styleHeader() -> some View {
        self
            .font(.custom("Lexend-Bold", size: 16))
            .foregroundStyle(Color.primary)
            .kerning(0) // 0% letter spacing
            .multilineTextAlignment(.leading)
    }
    
    func styleSubtitle() -> some View {
        self
            .font(.custom("Lexend-Medium", size: 12))
            .foregroundStyle(Color("ColorTextSecondary"))
            .kerning(0) // 0% letter spacing
            .multilineTextAlignment(.leading)
    }
}
