//
//  ExercisesListView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import SwiftUI

@MainActor
struct ExercisesListView: View {
    @State private var session = SessionViewModel.shared
    @State private var viewModel = ExercisesListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.exercises, id: \.id) { exercise in
                ZStack {
                    CardView(exercise: exercise)

                    NavigationLink {
                        ExerciseDetailPage(exerciseID: exercise.id)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } 
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .top, spacing: 0) {
            if session.isAuthenticated && !viewModel.availableDifficulties.isEmpty {
                difficultyFilters
            }
        }
        .overlay {
            if viewModel.isLoading && viewModel.exercises.isEmpty {
                ProgressView("Loading exercises...")
            } else if let error = viewModel.errorMessage, viewModel.exercises.isEmpty {
                VStack(spacing: 8) {
                    Text(error).foregroundStyle(.red)
                    Button("Try again") {
                        Task { await viewModel.loadExercises() }
                    }
                }
            } else {
                if !viewModel.isLoading && viewModel.errorMessage == nil && viewModel.exercises.isEmpty {
                    ContentUnavailableView("There are no exercises", systemImage: "figure.strengthtraining.traditional")
                }
            }
        }
        .task {
            if viewModel.exercises.isEmpty {
                await viewModel.loadExercises()
            }
        }
        .refreshable {
            await viewModel.loadExercises()
        }
    }

    private var difficultyFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button {
                    viewModel.clearDifficultyFilter()
                } label: {
                    Text("All")
                        .font(.custom("Lexend-Medium", size: 12))
                        .foregroundStyle(viewModel.selectedDifficulty == nil ? .white : Color("ColorTextTagPill"))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(viewModel.selectedDifficulty == nil ? Color("ColorBrandGreen") : Color("ColorPillBackground"))
                        )
                }
                .buttonStyle(.plain)

                ForEach(viewModel.availableDifficulties, id: \.self) { difficulty in
                    Button {
                        viewModel.toggleDifficulty(difficulty)
                    } label: {
                        Text(difficulty.capitalizedFirstLetter)
                            .font(.custom("Lexend-Medium", size: 12))
                            .foregroundStyle(viewModel.selectedDifficulty == difficulty ? .white : Color("ColorTextTagPill"))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(viewModel.selectedDifficulty == difficulty ? Color("ColorBrandGreen") : Color("ColorPillBackground"))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(
            Color("ColorAppBackground")
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
}


#Preview {
    ExercisesListView()
}
