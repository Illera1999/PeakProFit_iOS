//
//  ExerciseEntity.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 15/3/26.
//

import Foundation

struct ExerciseEntity: Identifiable, Equatable {
    let id: String
    let name: String
    let targetMuscles: [String]
    let equipments: [String]
    let difficulty: String?
}
