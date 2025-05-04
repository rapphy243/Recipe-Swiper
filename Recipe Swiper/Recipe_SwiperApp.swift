//
//  Recipe_SwiperApp.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftData
import SwiftUI

@main
struct Recipe_SwiperApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RecipeModel.self,
            AnalyzedInstructionModel.self,
            InstructionStepModel.self,
            InstructionComponentModel.self,
            InstructionLengthModel.self,
            MeasuresModel.self,
            MeasurementUnitModel.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
