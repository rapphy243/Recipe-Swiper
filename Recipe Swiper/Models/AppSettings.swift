//
//  AppSettings.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/29/25.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    // API Settings
    @AppStorage("apiKey") var apiKey: String = ""

    // User Preferences
    @AppStorage("swipeSensitivity") var swipeSensitivity: Double = 100.0

    // AI Features
    @AppStorage("enableAIFeatures") var enableAIFeatures: Bool = true
    @AppStorage("aiRecipeSummary") var aiRecipeSummary: Bool = true

    // App Behavior
    @AppStorage("hapticFeedbackEnabled") var hapticFeedbackEnabled: Bool = true

    private init() {}
}
