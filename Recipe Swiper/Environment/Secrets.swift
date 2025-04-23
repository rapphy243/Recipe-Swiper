//
//  Secrets.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/13/25.
//
//  Generated with Gemini 2.5 Pro
//  Modified to allow runtime override

import Foundation

struct Secrets {
    // Define an enum for keys to avoid typos
    private enum Keys: String {
        case apiKey = "ApiKey" // Matches the key in Info.plist
    }

    // --- Private storage for the potentially overridden key ---
    // This will hold the key currently in use. It starts as nil.
    private static var currentApiKey: String? = nil
    // Lock for thread safety when accessing/modifying currentApiKey
    private static let lock = NSLock()
    // ---

    // Private function to retrieve the *initial* value from Info.plist
    private static func initialInfoValue(forKey key: Keys) -> String? {
        // Attempt to find the Info.plist dictionary
        guard let infoDict = Bundle.main.infoDictionary else {
            // This should ideally not happen if Info.plist exists
            print("Error: Could not find Info.plist bundle dictionary.")
            return nil
        }
        // Attempt to get the value for the specified key
        guard let value = infoDict[key.rawValue] as? String else {
            print(
                "Warning: Key '\(key.rawValue)' not found or not a String in Info.plist."
            )
            return nil // Key missing in plist
        }
        // Basic check to ensure it's not the placeholder or empty
        if value.contains("$(API_KEY)") || value.isEmpty {
            print(
                "Warning: API Key seems to be missing or not replaced in Info.plist."
            )
            return nil // Placeholder or empty value found
        }
        return value
    }

    // Public accessor for the API key
    static var apiKey: String {
        lock.lock() // Ensure thread safety
        defer { lock.unlock() } // Ensure lock is always released

        // If we already have a key set (either initially or via setApiKey), return it
        if let key = currentApiKey {
            return key
        }

        // --- First time access: Try to load from Info.plist ---
        if let initialKey = initialInfoValue(forKey: .apiKey) {
            currentApiKey = initialKey // Store the initial key
            return initialKey
        } else {
            // Handle the missing key scenario appropriately for your app.
            let errorMessage =
                "Secrets.xcconfig: API Key not found or invalid in Info.plist. Make sure it's set or restart Xcode."
            print(errorMessage)
            currentApiKey = errorMessage // Store the error message to avoid re-checking
            return errorMessage
        }
        // ---
    }

    // --- Function to change the API key at runtime ---
    /// Sets a new API key for the current app session.
    /// Note: This change is NOT persisted across app launches unless you
    /// add persistence logic (e.g., save to UserDefaults or Keychain).
    /// - Parameter newKey: The new API key string to use. If nil or empty,
    ///   it might revert to the initial key or an error state on next access
    ///   depending on implementation details (currently just sets it).
    ///   Consider adding validation if needed.
    static func setApiKey(_ newKey: String?) {
        lock.lock() // Ensure thread safety
        defer { lock.unlock() } // Ensure lock is always released

        // You might want to add validation here (e.g., check if empty)
        // if newKey?.isEmpty ?? true {
        //     print("Warning: Attempted to set an empty API key.")
        //     // Decide how to handle this: maybe revert to initial, maybe allow it
        // }

        print("API Key changed at runtime.") // Good for debugging
        currentApiKey = newKey // Update the stored key
    }

    /// Resets the API key to the value originally loaded from Info.plist.
    static func resetApiKeyToInitial() {
        lock.lock()
        defer { lock.unlock() }

        print("Resetting API Key to initial value from Info.plist.")
        // Setting to nil forces the getter to re-evaluate initialInfoValue on next access
        currentApiKey = nil
        // Trigger the getter once to reload/cache the initial value or error message
        _ = apiKey
    }
    // ---
}
