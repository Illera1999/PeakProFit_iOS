//
//  ExerciseMapper.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 15/3/26.
//

import Foundation

enum ExerciseMapper {
    static func toEntity(_ dto: ExerciseDto) -> ExerciseEntity {
        ExerciseEntity(
            id: dto.id,
            name: dto.name,
            targetMuscles: [dto.target],
            equipments: [dto.equipment]
        )
    }
}
