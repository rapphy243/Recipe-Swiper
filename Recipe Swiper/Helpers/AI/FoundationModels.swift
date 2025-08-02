//
//  FoundationModels.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/3/25.
//

import Foundation
import FoundationModels

struct ModelHelper {
    static private var model = SystemLanguageModel.default
    
    static var availabilityDescription: String {
        switch self.model.availability {
        case .available:
            return "Device Eligible"
        case .unavailable(.deviceNotEligible):
            return "Device not Eligible"
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Apple Intelligence not enabled"
        case .unavailable(.modelNotReady):
            return "Model not ready"
        case .unavailable(let other):
            return "Unavailable for an unknown reason: \(other)"
        }
    }
    
    static var isAvailable: Bool {
        return model.availability == .available
    }
}
