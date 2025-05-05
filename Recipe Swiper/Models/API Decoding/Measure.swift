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
struct Measures: Codable, Hashable {
    var us: MeasurementUnit
    var metric: MeasurementUnit
    static let empty = Measures(
        us: MeasurementUnit.empty,
        metric: MeasurementUnit.empty
    )
}

// MARK: - MeasurementUnit
// Represents a specific measurement unit with amount and names.
struct MeasurementUnit: Codable, Hashable {
    var amount: Double
    var unitShort: String
    var unitLong: String

    static let empty = MeasurementUnit(amount: 0.0, unitShort: "", unitLong: "")
}
