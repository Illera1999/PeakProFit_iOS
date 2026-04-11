//
//  ExerciseDetailMapper.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import Foundation

enum ExerciseDetailMapper {
    static func toEntity(_ dto: ExerciseDetailDto) -> ExerciseDetailEntity {
        ExerciseDetailEntity(
            id: dto.id,
            name: dto.name,
            equipments: [dto.equipment],
            secondaryMuscles: dto.secondaryMuscles,
            instructions: dto.instructions
        )
    }
}
