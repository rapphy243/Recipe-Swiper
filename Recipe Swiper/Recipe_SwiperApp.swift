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
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate // See class all the way below
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ // What objects that are going to be in the container
            RecipeModel.self,
            AnalyzedInstructionModel.self,
            InstructionStepModel.self,
            InstructionComponentModel.self,
            InstructionLengthModel.self,
            MeasuresModel.self,
            MeasurementUnitModel.self,
        ])
        let modelConfiguration = ModelConfiguration( // Configuration for the model container
            schema: schema, // the objects above
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer( // Inialize the container for the data we are storing
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

// Not ideal, but edits AppDelegate (root object of app) to lock app to portrait mode.
// https://developer.apple.com/forums/thread/741703
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .portrait
    }
}
