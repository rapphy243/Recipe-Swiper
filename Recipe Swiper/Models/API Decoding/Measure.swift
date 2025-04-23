//
//  Measure.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//

//  Query decoded with Gemini 2.5 Pro

import Foundation

// MARK: - Measures
// Contains measurement details in US and metric units.
struct Measures: Codable {
    let us: MeasurementUnit
    let metric: MeasurementUnit
}

// MARK: - MeasurementUnit
// Represents a specific measurement unit with amount and names.
struct MeasurementUnit: Codable {
    let amount: Double
    let unitShort: String
    let unitLong: String
}
