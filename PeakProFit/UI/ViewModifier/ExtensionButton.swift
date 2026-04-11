//
//  ExtensionButton.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

import SwiftUI

extension View {
    func styleAuthPrimaryButton() -> some View {
        self
            .font(.custom("Lexend-SemiBold", size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color("ColorBrandGreen"))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

extension Button where Label == Text {
    func styleDangerActionButton() -> some View {
        self
            .font(.custom("Lexend-SemiBold", size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

