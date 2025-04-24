//
//  Recipe_SwiperApp.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI
import SwiftData

@main
struct Recipe_SwiperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [RecipeModel.self])
    }
}
