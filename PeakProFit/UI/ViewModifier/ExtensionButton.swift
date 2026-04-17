//
//  ExtensionButton.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 29/3/26.
//

import SwiftUI

extension View {
    func styleAuthPrimaryButton(backgroundColor: Color = Color("ColorBrandGreen")) -> some View {
        let shape = RoundedRectangle(cornerRadius: 18, style: .continuous)

        return self
            .font(.custom("Lexend-SemiBold", size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(backgroundColor)
            .clipShape(shape)
            .contentShape(shape)
    }
}

extension Button where Label == Text {
    func styleDangerActionButton() -> some View {
        let shape = RoundedRectangle(cornerRadius: 14, style: .continuous)

        return self
            .font(.custom("Lexend-SemiBold", size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.red)
            .clipShape(shape)
            .contentShape(shape)
    }
}
