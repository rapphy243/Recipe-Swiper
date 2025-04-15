//
//  API.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/14/25.
//
// Generated with Gemini 2.5 Pro Prompt: "I want to create a function that returns the recipe from the API"

import Foundation

enum RecipeError: Error, LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed(Error)
    case noRecipeFound
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided API endpoint URL was invalid."
        case .requestFailed(let statusCode):
            return "The network request failed with status code: \(statusCode)."
        case .decodingFailed(let underlyingError):
            return "Failed to decode the JSON response: \(underlyingError.localizedDescription)"
        case .noRecipeFound:
            return "The API response did not contain any recipes."
        case .unknown(let underlyingError):
            return "An unknown error occurred: \(underlyingError.localizedDescription)"
        }
    }
}

func fetchRandomRecipe() async throws -> Recipe {
    let urlString = "https://api.spoonacular.com/recipes/random?apiKey=" + Secrets.apiKey
    guard let url = URL(string: urlString) else {
        throw RecipeError.invalidURL
    }
    print("Fetching recipe from: \(url.absoluteString)") // Debugging

    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
             throw RecipeError.unknown(NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type received."]))
        }
        print("Received HTTP status code: \(httpResponse.statusCode)") // Debugging

        guard (200...299).contains(httpResponse.statusCode) else {
            throw RecipeError.requestFailed(statusCode: httpResponse.statusCode)
        }

        // Decode the JSON data
        let decoder = JSONDecoder()
        let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)

        // The /random endpoint returns a 'recipes' array, usually with one item.
        guard let recipe = recipeResponse.recipes.first else {
            throw RecipeError.noRecipeFound
        }
        return recipe

    } catch let error as DecodingError {
        // Catch specific decoding errors for better debugging
        print("Decoding Error Details: \(error)")
        throw RecipeError.decodingFailed(error)
    } catch let error as RecipeError {
        // Re-throw known RecipeErrors
        throw error
    } catch {
        // Catch any other unexpected errors
        throw RecipeError.unknown(error)
    }
}
