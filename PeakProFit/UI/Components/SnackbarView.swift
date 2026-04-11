import SwiftUI
import Observation

enum SnackbarStyle {
    case success
    case error
    case info

    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        case .info: return "info.circle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .info: return .blue
        }
    }
}

struct SnackbarItem: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let style: SnackbarStyle
}

@MainActor
@Observable
final class SnackbarCenter {
    static let shared = SnackbarCenter()

    var item: SnackbarItem?
    private var dismissTask: Task<Void, Never>?

    func show(message: String, style: SnackbarStyle = .info, duration: TimeInterval = 2.5) {
        dismissTask?.cancel()
        withAnimation(.spring(duration: 0.25)) {
            item = SnackbarItem(message: message, style: style)
        }

        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            self?.dismiss()
        }
    }

    func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            item = nil
        }
    }
}

struct SnackbarView: View {
    let item: SnackbarItem

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: item.style.iconName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(item.style.tint)

            Text(item.message)
                .font(.custom("Lexend-Medium", size: 13))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(item.style.tint.opacity(0.25), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 5)
    }
}

private struct SnackbarPresenterModifier: ViewModifier {
    @State private var snackbar = SnackbarCenter.shared

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let item = snackbar.item {
                    SnackbarView(item: item)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 22)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
    }
}

extension View {
    func withSnackbar() -> some View {
        modifier(SnackbarPresenterModifier())
    }
}
