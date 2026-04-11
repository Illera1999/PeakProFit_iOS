//
//  ExerciseDetailDto.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

struct ExerciseDetailDto: Decodable {
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
