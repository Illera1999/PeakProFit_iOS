//
//  ExerciseDto.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 15/3/26.
//

struct ExerciseDto: Decodable {
    let id: String
    let name: String
    let bodyPart: String
    let target: String
    let equipment: String
    let secondaryMuscles: [String]
    let instructions: [String]
    let description: String?
    let difficulty: String?
    let category: String?
}
