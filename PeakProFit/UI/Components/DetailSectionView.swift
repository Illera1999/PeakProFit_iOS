//
//  DetailSectionView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 25/3/26.
//

import SwiftUI

struct DetailSectionView<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.capitalizedFirstLetter)
                .styleHeader()
            content()
        }
    }
}

