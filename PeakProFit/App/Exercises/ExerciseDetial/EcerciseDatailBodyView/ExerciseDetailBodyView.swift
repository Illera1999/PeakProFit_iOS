//
//  ExerciseDetailBodyView.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 25/3/26.
//

import SwiftUI

struct ExerciseDetailBodyView: View {
    
    let exercise: ExerciseDetailEntity
    let imageURL: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ImageCardView(
                    url: imageURL,
                    width: nil,
                    height: 220,
                    cornerRadius: 16
                )
                
                Text(exercise.name.capitalizedFirstLetter)
                    .stylePageTitle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                DetailSectionView(title: "Equipments") {
                    tagRow(exercise.equipments)
                }
                
                DetailSectionView(title: "Secondary muscles") {
                    tagRow(exercise.secondaryMuscles)
                }
                
                DetailSectionView(title: "Instructions") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                            Text("\(index + 1). \(instruction.capitalizedFirstLetter)")
                                .styleSubtitle()
                        }
                    }
                }
            }
            .padding(16)
        }
    }
    
    @ViewBuilder
    private func tagRow(_ values: [String]) -> some View {
        if values.isEmpty {
            Text("No data")
                .styleSubtitle()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(values, id: \.self) { value in
                        TagPillView(title: value)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}

#Preview {
    ExerciseDetailBodyView(
        exercise: ExerciseDetailEntity(
            id: "ztAa1RK",
            name: "press de banca",
            equipments: ["barra", "banco"],
            secondaryMuscles: ["triceps", "hombros"],
            instructions: ["acuestate en el banco", "agarra la barra", "empuja hacia arriba controlando el movimiento"],
            difficulty: "beginner"
        ),
        imageURL: URL(string: "https://exercisedb.p.rapidapi.com/image?exerciseId=ztAa1RK&resolution=360&rapidapi-key=YOUR_API_KEY")
    )
}
