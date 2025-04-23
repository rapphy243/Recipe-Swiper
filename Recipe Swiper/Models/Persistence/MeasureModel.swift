//
//  RecipeInstructionModel.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//
//  Generated with Claude 3.5 Sonnet

import Foundation
import SwiftData

@Model
final class MeasuresModel {
    var us: MeasurementUnitModel
    var metric: MeasurementUnitModel
    
    init(from measures: Measures) {
        self.us = MeasurementUnitModel(from: measures.us)
        self.metric = MeasurementUnitModel(from: measures.metric)
    }
}

@Model
final class MeasurementUnitModel {
    var amount: Double
    var unitShort: String
    var unitLong: String
    
    init(from unit: MeasurementUnit) {
        self.amount = unit.amount
        self.unitShort = unit.unitShort
        self.unitLong = unit.unitLong
    }
}
