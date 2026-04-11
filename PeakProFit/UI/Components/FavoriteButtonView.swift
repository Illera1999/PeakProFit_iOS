import SwiftUI

struct FavoriteButtonView: View {
    let isFavorite: Bool
    let isUpdating: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: isFavorite ? "checkmark.circle.fill" : "plus.circle")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(isFavorite ? Color.green : Color("ColorTextSecondary"))
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.plain)
        .disabled(isUpdating)
    }
}

