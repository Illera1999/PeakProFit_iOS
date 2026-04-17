//
//  ExerciseDetailEntity.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import Foundation

struct ExerciseDetailEntity: Identifiable, Equatable {
    let id: String
    let name: String
    let equipments: [String]
    let secondaryMuscles: [String]
    let instructions: [String]
    let difficulty: String?
}
