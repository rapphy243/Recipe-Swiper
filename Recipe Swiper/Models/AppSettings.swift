//
//  AppSettings.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/29/25.
//

import SwiftUI

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    // API Settings
    @AppStorage("apiKey") var apiKey: String = ""

    // User Preferences
    @AppStorage("swipeSensitivity") var swipeSensitivity: Double = 200.0

    // AI Features
    @AppStorage("enableAIFeatures") var enableAIFeatures: Bool = true
    @AppStorage("aiRecipeSummary") var aiRecipeSummary: Bool = true

    // App Behavior
    @AppStorage("hapticFeedbackEnabled") var hapticFeedbackEnabled: Bool = true
    
    // Main View Background Colors https://iosref.com/uihex
    @AppStorage("backgroundColor1") var backgroundColor1: Color = Color(red: 1, green: 0.969, blue: 0.678) // #fff7ad
    @AppStorage("backgroundColor2") var backgroundColor2: Color = Color(red: 1, green: 0.663, blue: 0.976) // #ffa9f9
    @AppStorage("backgroundDarkColor1") var backgroundDarkColor1: Color = Color(red: 0.04, green: 0.04, blue: 0.31) // #0a0a4f
    @AppStorage("backgroundDarkColor2") var backgroundDarkColor2: Color = Color(red: 0.37, green: 0.10, blue: 0.54) // #5e1a8a
    
    private init() {}
}

// https://stackoverflow.com/questions/73184367/saving-color-to-userdefaults-and-use-it-from-appstorage
extension Color: @retroactive RawRepresentable
{
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .black
            return
        }

        do {
            if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
                self = Color(color)
            } else {
                self = .black
            }
        } catch {
            self = .black
        }
    }

    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}

