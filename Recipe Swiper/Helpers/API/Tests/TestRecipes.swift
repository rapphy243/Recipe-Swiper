// Generated with Gemini 2.5 Pro
// Used to provide recipes that can be called without using API.

import Foundation

// MARK: - RecipeLoader Singleton
// Loads predefined recipes from the app bundle upon first access.
final class RecipeLoader {

    // --- Shared Instance ---
    // Access the loaded recipes via this static property
    static let shared = RecipeLoader()

    // --- Predefined Recipe Properties ---
    // These will hold the loaded recipes.
    let cake: Recipe?
    let curry: Recipe?
    let salad: Recipe?

    // Keep track of all loaded recipes if needed
    let allRecipes: [Recipe]

    // --- Private Initializer ---
    // Ensures only one instance is created (Singleton pattern).
    // Loads the recipes immediately when the instance is created.
    private init() {
        print("⚙️ Initializing RecipeLoader...")
        // Load each predefined recipe
        self.cake = RecipeLoader.loadRecipe(from: "Cake")
        self.curry = RecipeLoader.loadRecipe(from: "Curry")
        self.salad = RecipeLoader.loadRecipe(from: "Salad")

        // Populate the allRecipes array with non-nil recipes
        self.allRecipes = [cake, curry, salad].compactMap { $0 }

        print("✅ RecipeLoader initialized. Loaded \(allRecipes.count) recipes.")
        if cake == nil { print("⚠️ Warning: Cake.json failed to load.") }
        if curry == nil { print("⚠️ Warning: Curry.json failed to load.") }
        if salad == nil { print("⚠️ Warning: Salad.json failed to load.") }
    }

    // --- Private Loading Helper Function ---
    /// Loads and decodes the *first* recipe from a JSON file in the main bundle.
    /// Assumes the JSON file contains a `RecipeResponse` structure.
    /// - Parameter filename: The name of the JSON file (without the .json extension).
    /// - Returns: The decoded `Recipe` object, or `nil` if loading/decoding fails.
    private static func loadRecipe(from filename: String) -> Recipe? {
        // 1. Find the file URL
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("❌ Error: Recipe file '\(filename).json' not found in bundle.")
            return nil
        }

        // 2. Load the data
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("❌ Error: Could not load data from '\(filename).json'. \(error)")
            return nil
        }

        // 3. Decode the JSON data
        let decoder = JSONDecoder()
        do {
            // Assumes the file structure is {"recipes": [Recipe, ...]}
            let response = try decoder.decode(RecipeResponse.self, from: data)
            // Return the *first* recipe found in the file's array
            if let recipe = response.recipes.first {
                print("👍 Successfully loaded recipe from '\(filename).json'")
                return recipe
            } else {
                print("❌ Error: No recipes found inside the 'recipes' array in '\(filename).json'.")
                return nil
            }
        } catch {
            // Provide detailed decoding error
            //var errorDesc = error.localizedDescription
            //print("❌ Error: Failed to decode '\(filename).json'. \(errorDesc)")
            return nil
        }
    }
}

// MARK: - How to Use (Example)
/*
 // In any part of your code (e.g., a SwiftUI View, a ViewController, etc.)
 let loader = RecipeLoader.shared
 let cakeRecipe = loader.cake // This is a recipe
*/
