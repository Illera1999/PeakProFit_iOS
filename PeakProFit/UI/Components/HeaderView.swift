//
//  PageHeaderView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    var showsBackButton: Bool = false
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text(title).stylePageTitle()
                
                HStack {
                    if showsBackButton {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color.primary)
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Spacer()
                }
            }
            .padding(16)
            Divider()
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    VStack(spacing: 24) {
        HeaderView(title: "Exercises")
        HeaderView(title: "Detail", showsBackButton: true)
    }
}
