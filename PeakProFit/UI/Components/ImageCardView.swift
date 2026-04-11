//
//  ImageCardView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 15/3/26.
//
import SwiftUI
import SDWebImageSwiftUI

struct ImageCardView: View {
    let url: URL?
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(
        url: URL?,
        width: CGFloat? = 80,
        height: CGFloat = 80,
        cornerRadius: CGFloat = 12
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        ZStack {
            placeholder

            if let url {
                AnimatedImage(url: url)
                    .indicator(.activity)
                    .onFailure { error in
                        print("Image error: \(error.localizedDescription)")
                    }
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(maxWidth: width == nil ? .infinity : nil)
        .frame(width: width, height: height)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .font(.title2)
            .foregroundStyle(.secondary)
    }
}


#Preview {
    VStack(spacing: 20) {
        ImageCardView(url: URL(string: "https://picsum.photos/200"))   // debería cargar
        ImageCardView(url: URL(string: ""))                           // placeholder
        ImageCardView(url: URL(string: "mal-url"))                    // placeholder
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
