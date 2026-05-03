//
//  TagPillView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//
import SwiftUI

struct TagPillView: View {
    let title: String

    var body: some View {
        Text(title.capitalizedFirstLetter)
            .font(.custom("Lexend-Medium", size: 12))
            .foregroundStyle(Color("ColorTextTagPill"))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(Color("ColorPillBackground"))
            )
            .fixedSize() // evita que se estire raro
    }
}
