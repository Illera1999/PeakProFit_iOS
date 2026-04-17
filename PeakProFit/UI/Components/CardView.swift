//
//  ExerciseCardView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 15/3/26.
//

import SwiftUI
import FirebaseAuth

struct CardView: View {
    let exercise: ExerciseEntity
    @State private var session = SessionViewModel.shared
    @State private var isFavorite = false
    @State private var isUpdatingFavorite = false

    private let favoritesStore = FavoritesStore.shared
    private let dataSource: any DataSourceProtocol = AppContainer.shared.exercisesDataSource

    var body: some View {
        HStack(alignment: .top, spacing: 18){
            VStack(alignment: .leading, spacing: 4){
                Text(exercise.name.capitalizedFirstLetter)
                    .styleHeader()
                Text(exercise.targetMuscles.joined(separator: " . ").capitalizedFirstLetter)
                    .styleSubtitle()
                HStack(){
                    ForEach(exercise.equipments, id: \.self){equipments in
                        TagPillView(title: equipments)
                    }
                }.padding(.top, 8)
            }
            .layoutPriority(3)
            Spacer(minLength: 0)

            if session.isAuthenticated {
                FavoriteButtonView(
                    isFavorite: isFavorite,
                    isUpdating: isUpdatingFavorite,
                    onTap: toggleFavorite
                )
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 6)
        .task(id: session.currentUser?.uid) {
            refreshFavoriteState()
        }
    }

    private func toggleFavorite() {
        Task {
            await toggleFavoriteAsync()
        }
    }

    private func toggleFavoriteAsync() async {
        guard let userId = session.currentUser?.uid else { return }
        isUpdatingFavorite = true
        defer { isUpdatingFavorite = false }

        do {
            if isFavorite {
                try favoritesStore.removeFavorite(userId: userId, exerciseId: exercise.id)
                isFavorite = false
                SnackbarCenter.shared.show(
                    message: "Exercise removed from saved list.",
                    style: .info
                )
            } else {
                try favoritesStore.saveFavorite(exercise: exercise, userId: userId)
                isFavorite = true
                await enrichSavedExerciseInfo(userId: userId)
                SnackbarCenter.shared.show(
                    message: "Exercise saved successfully.",
                    style: .success
                )
            }
        } catch {
            print("[CardView] Favorite toggle failed: \(error.localizedDescription)")
            SnackbarCenter.shared.show(
                message: "We couldn't update saved exercises. Please try again.",
                style: .error
            )
        }
    }

    private func enrichSavedExerciseInfo(userId: String) async {
        do {
            let detail = try await dataSource.getExerciseDetail(exerciseID: exercise.id)
            try favoritesStore.updateStoredExerciseInfo(
                userId: userId,
                exerciseId: exercise.id,
                instructions: detail.instructions,
                difficulty: detail.difficulty ?? exercise.difficulty
            )
        } catch {
            print("[CardView] Could not cache extra favorite info: \(error.localizedDescription)")
        }
    }

    private func refreshFavoriteState() {
        guard let userId = session.currentUser?.uid else {
            isFavorite = false
            return
        }
        isFavorite = favoritesStore.isFavorite(userId: userId, exerciseId: exercise.id)
    }
}

#Preview {
    CardView(exercise: ExerciseEntity(
        id: "bench_press_01",
        name: "press de banca",
        targetMuscles: ["Pectoral", "De locos"],
        equipments: ["Barra", "Piso"],
        difficulty: "beginner"
    ))
}
