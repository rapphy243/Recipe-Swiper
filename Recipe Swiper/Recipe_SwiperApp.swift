//
//  Recipe_SwiperApp.swift
//  Recipe Swiper
//
//  Created by Snack Swipe Team (Zane, Tyler, Rapphy) on 4/11/25.
//

import SwiftData
import SwiftUI

@MainActor
class AppData: ObservableObject {
    @Published var recipe: Recipe
    @Published var isLoading: Bool
    @Published var recipeError: Error?

    init(recipe: Recipe) {
        self.recipe = recipe
        self.isLoading = false
    }
    init() {
        if let recipeData = UserDefaults.standard.data(forKey: "recipe"),
            let decodedRecipe = try? JSONDecoder().decode(
                Recipe.self,
                from: recipeData
            )
        {
            self.recipe = decodedRecipe
        } else {
            self.recipe = Recipe.empty
        }
        self.isLoading = false
    }

    func fetchNewRecipe() async {
        isLoading = true
        recipeError = nil
        do {
            let fetched = try await fetchRandomRecipe()
            self.recipe = fetched
            UserDefaults.standard.set(
                try? JSONEncoder().encode(fetched),
                forKey: "recipe"
            )
            isLoading = false
            try? await self.recipe.generateSummary()
        } catch {
            isLoading = false
            recipeError = error
        }
    }
}

// https://medium.com/@manikantasirumalla5/handling-swiftdata-schema-migrations-a-practical-guide-e58e05bd3071
struct DatabaseManager {
    static let schema = Schema([  // What objects that are going to be in the container
        RecipeModel.self,
        AnalyzedInstructionModel.self,
        InstructionStepModel.self,
        InstructionComponentModel.self,
        InstructionLengthModel.self,
        MeasuresModel.self,
        MeasurementUnitModel.self,
    ])
    static let configuration = ModelConfiguration(  // Configuration for the model container
        schema: schema,  // the objects above
        isStoredInMemoryOnly: false
    )
    
    static func setupModelContainer() -> ModelContainer? {
        // FIRST APPROACH: Try creating a model container normally
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            print("Error creating standard container: \(error)")
            print("Attempting recovery...")
            
            // SECOND APPROACH: Delete the database and create a fresh one
            return attemptRecovery()
        }
    }
    
    // Recovery function - delete and recreate the database
    private static func attemptRecovery() -> ModelContainer? {
        let applicationSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let storeURL = applicationSupportURL.appending(path: "default.store")
        
        do {
            // Try to delete the database file
            if FileManager.default.fileExists(atPath: storeURL.path) {
                try FileManager.default.removeItem(at: storeURL)
                print("Removed corrupted database at: \(storeURL)")
            }
            
            let container = try ModelContainer(for: schema, configurations: [configuration])
            print("Successfully created fresh database")
            
            // Set flag to indicate this is a new database
            UserDefaults.standard.set(false, forKey: "didGenerateInitialData")
            
            return container
        } catch {
            print("Recovery attempt failed: \(error)")
            
            // THIRD APPROACH: In-memory container
            do {
                print("Creating fallback in-memory container")
                let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                return try ModelContainer(
                    for: schema,
                    configurations: fallbackConfig
                )
            } catch {
                print("Failed to create even a fallback container: \(error)")
                return nil
            }
        }
    }
}

@main
struct Recipe_SwiperApp: App {
    @StateObject private var appData = AppData()  // We need the Recipe
    private let modelContainer: ModelContainer?

    // Initialize with proper error handling
    init() {
        modelContainer = DatabaseManager.setupModelContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            if let container = modelContainer {
                ContentView()
                    .modelContainer(container)
                    .environmentObject(appData)
            } else {
                ErrorView(message:"Could not initialize the database. Please restart the app.")
            }
        }
    }
}


struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Database Error")
                .font(.title)
                .fontWeight(.bold)
            
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Clear App Data & Restart") {
                // Clear UserDefaults
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }
                
                // Try to delete the database file
                let applicationSupportURL = FileManager.default.urls(
                    for: .applicationSupportDirectory,
                    in: .userDomainMask
                ).first!
                let storeURL = applicationSupportURL.appending(path: "default.store")
                
                do {
                    if FileManager.default.fileExists(atPath: storeURL.path) {
                        try FileManager.default.removeItem(at: storeURL)
                    }
                } catch {
                    print("Failed to delete database: \(error)")
                }
                
                // Restart the app
                exit(0)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
