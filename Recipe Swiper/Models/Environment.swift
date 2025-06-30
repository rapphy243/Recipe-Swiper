//
//  Environment.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/29/25.
//

import Foundation

struct Env {
    static var apiKey: String {
        guard let savedAPIKey = UserDefaults.standard.string(forKey: "apiKey") else {
            UserDefaults.standard.set("", forKey: "apiKey")
            print("No API key saved.")
            return ""
        }
        return savedAPIKey
    }
}
