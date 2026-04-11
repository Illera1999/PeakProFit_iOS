//
//  ExerciseDetialView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExerciseDetailPage: View {

    let exerciseID: String
    @State private var viewModel: ExerciseDetailViewModel

    init(exerciseID: String) {
        self.exerciseID = exerciseID
        _viewModel = State(
            initialValue: ExerciseDetailViewModel(exerciseID: exerciseID)
        )
    }
    
    var body: some View {
        VStack{
            HeaderView(title: "Detail", showsBackButton: true)
            if viewModel.isLoading && viewModel.exercise == nil {
                ProgressView("Loading...")
            } else if let exercise = viewModel.exercise {
               ExerciseDetailBodyView(exercise: exercise, imageURL: viewModel.exerciseImageURL)
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text(error).foregroundStyle(.red)
                    Button("Try again") {
                        Task { await viewModel.loadExercise() }
                    }
                }
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemGray6))
        .toolbar(.hidden, for: .navigationBar)
        .task {
            if viewModel.exercise == nil {
                await viewModel.loadExercise()
            }
        }
    }
}

#Preview {
    ExerciseDetailPage(exerciseID: "ztAa1RK")
}
