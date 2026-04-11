//
//  ExercisesListView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import SwiftUI

struct ExercisesListView: View {
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
}


#Preview {
    ExercisesListView()
}
