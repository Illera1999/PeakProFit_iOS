import Foundation
import Observation

@MainActor
@Observable
final class SavedExercisesListViewModel {
    var exercises: [ExerciseEntity] = []
    var isLoading = false
    var errorMessage: String?

    private let favoritesStore: FavoritesStore

    init(favoritesStore: FavoritesStore? = nil) {
        self.favoritesStore = favoritesStore ?? .shared
    }

    func loadFavorites(userId: String?) {
        guard let userId, !userId.isEmpty else {
            exercises = []
            errorMessage = nil
            isLoading = false
            return
        }

        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            exercises = try favoritesStore.fetchFavorites(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
