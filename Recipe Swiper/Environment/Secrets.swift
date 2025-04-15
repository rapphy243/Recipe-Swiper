//
//  Secrets.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/13/25.
//
//  Generated with Gemini 2.5 Pro

import Foundation

struct Secrets {
    // Define an enum for keys to avoid typos
    private enum Keys: String {
        case apiKey = "3939d6a64e164fa591ca7873112ce119" // Matches the key in Info.plist
    }

    // Private function to retrieve value from Info.plist
    private static func infoValue(forKey key: Keys) -> String? {
        // Attempt to find the Info.plist dictionary
        guard let infoDict = Bundle.main.infoDictionary else {
            fatalError("Could not find Info.plist")
        }
        // Attempt to get the value for the specified key
        guard let value = infoDict[key.rawValue] as? String else {
            // Consider logging an error here instead of fatalError in production
            print("Warning: Key '\(key.rawValue)' not found or not a String in Info.plist.")
            return nil // Or handle appropriately (e.g., return a default, throw error)
        }
        // Basic check to ensure it's not the placeholder if you forget to set it
        if value.contains("$(API_KEY)") || value.isEmpty {
             print("Warning: API Key seems to be missing or not replaced in Info.plist.")
             return nil // Or handle appropriately
        }
        return value
    }

    // Public accessor for the API key
    static var apiKey: String {
        guard let key = infoValue(forKey: .apiKey) else {
            // Handle the missing key scenario appropriately for your app.
            // Crashing might be okay in debug, but not production.
            // Maybe return a dummy key, show an error, or disable functionality.
            //fatalError("API Key not found in Info.plist. Make sure it's set in Secrets.xcconfig and Info.plist.")
            return "Secrets.xcconfig: API Key not found. Make sure it's set or restart Xcode."
        }
        return key
    }
}

