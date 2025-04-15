// Generated with Gemini 2.5 Pro
// Used to provide recipes that can be called without using API.

import Foundation

func loadCakeRecipe() -> Recipe {
    return loadRecipeFromFile(named: "Cake") ?? Recipe.empty
}

/// Loads and returns the Curry recipe from "Curry.json".
/// - Returns: A `Recipe` object if loading and decoding are successful, otherwise `nil`.
func loadCurryRecipe() -> Recipe {
    return loadRecipeFromFile(named: "Curry") ?? Recipe.empty
}

/// Loads and returns the Salad recipe from "Salad.json".
/// - Returns: A `Recipe` object if loading and decoding are successful, otherwise `nil`.
func loadSaladRecipe() -> Recipe {
    return loadRecipeFromFile(named: "Salad") ?? Recipe.empty
}

/// Loads and decodes the *first* recipe from a specified JSON file in the main bundle.
/// Assumes the JSON file contains a `RecipeResponse` structure.
/// - Parameter filename: The name of the JSON file (without the .json extension).
/// - Returns: The decoded `Recipe` object, or `nil` if loading/decoding fails.
private func loadRecipeFromFile(named filename: String) -> Recipe? {
    // 1. Find the file URL
    guard
        let url = Bundle.main.url(forResource: filename, withExtension: "json")
    else {
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
            print(
                "❌ Error: No recipes found inside the 'recipes' array in '\(filename).json'."
            )
            return nil
        }
    } catch {
        // Provide detailed decoding error if needed
        print(
            "❌ Error: Failed to decode '\(filename).json'. \(error.localizedDescription)"
        )
        // You could add the prettyDecodingError helper call here too
        return nil
    }
}
