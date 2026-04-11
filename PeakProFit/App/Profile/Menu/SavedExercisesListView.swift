import SwiftUI
import FirebaseAuth

struct SavedExercisesListView: View {
    @State private var session = SessionViewModel.shared
    @State private var viewModel = SavedExercisesListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.exercises, id: \.id) { exercise in
                CardView(exercise: exercise)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .overlay {
            if viewModel.isLoading && viewModel.exercises.isEmpty {
                ProgressView("Loading saved exercises...")
            } else if let error = viewModel.errorMessage, viewModel.exercises.isEmpty {
                VStack(spacing: 8) {
                    Text(error).foregroundStyle(.red)
                    Button("Try again") {
                        viewModel.loadFavorites(userId: session.currentUser?.uid)
                    }
                }
            } else if viewModel.exercises.isEmpty {
                ContentUnavailableView("No saved exercises yet", systemImage: "bookmark")
            }
        }
        .task(id: session.currentUser?.uid) {
            viewModel.loadFavorites(userId: session.currentUser?.uid)
        }
        .onReceive(NotificationCenter.default.publisher(for: .favoritesDidChange)) { _ in
            viewModel.loadFavorites(userId: session.currentUser?.uid)
        }
        .refreshable {
            viewModel.loadFavorites(userId: session.currentUser?.uid)
        }
    }
}

#Preview {
    SavedExercisesListView()
}
