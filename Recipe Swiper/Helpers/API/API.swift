//
//  API.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/14/25.
//
// Generated with Gemini 2.5 Pro Prompt: "I want to create a function that returns the recipe from the API"

import Foundation
import SwiftUI

extension String {
    var htmlStripped: String {
        guard let data = self.data(using: .utf8) else { return self }
        if let attributed = try? NSAttributedString(data: data, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil) {
            return attributed.string
        }
        return self
    }
}

// Claude 3.5 Prompt: "I want to know how many api requests I have left. This is from the documentation..."
class APIQuota: ObservableObject {
    static let shared = APIQuota()  // Singleton instance

    @AppStorage("quotaRequest") private(set) var quotaRequest: Double = 0  // Points used by last request
    @AppStorage("quotaUsed") private(set) var quotaUsed: Double = 0  // Total points used today
    @AppStorage("quotaLeft") private(set) var quotaLeft: Double = 0  // Points remaining today

    func updateQuota(from headers: [AnyHashable: Any]) {
        if let requestQuota = headers["x-api-quota-request"] as? String,
            let requestValue = Double(requestQuota)
        {
            quotaRequest = requestValue
        }

        if let usedQuota = headers["x-api-quota-used"] as? String,
            let usedValue = Double(usedQuota)
        {
            quotaUsed = usedValue
        }

        if let leftQuota = headers["x-api-quota-left"] as? String,
            let leftValue = Double(leftQuota)
        {
            quotaLeft = leftValue
        }

        print(
            "Updated quota - Request: \(quotaRequest), Used: \(quotaUsed), Left: \(quotaLeft)"
        )
    }
}

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
            return
                "Failed to decode the JSON response: \(underlyingError.localizedDescription)"
        case .noRecipeFound:
            return "The API response did not contain any recipes."
        case .unknown(let underlyingError):
            return
                "An unknown error occurred: \(underlyingError.localizedDescription)"
        }
    }
}

func fetchRandomRecipe() async throws -> Recipe {

    var components = URLComponents(
        string: "https://api.spoonacular.com/recipes/random"
    )!

    components.queryItems = [
        URLQueryItem(name: "apiKey", value: AppSettings.shared.apiKey)
    ]

    guard let url = components.url else {
        throw RecipeError.invalidURL
    }
    print("Fetching recipe from: \(url.absoluteString)")  // Debugging

    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RecipeError.unknown(
                NSError(
                    domain: "NetworkError",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Invalid response type received."
                    ]
                )
            )
        }

        // Update quota information from response headers
        APIQuota.shared.updateQuota(from: httpResponse.allHeaderFields)

        print("Received HTTP status code: \(httpResponse.statusCode)")  // Debugging
        print("API Quota remaining: \(APIQuota.shared.quotaLeft)")  // Debugging quota

        // Handle payment required error specifically
        if httpResponse.statusCode == 402 {
            throw RecipeError.requestFailed(statusCode: 402)
        }

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
        return Recipe(
            id: recipe.id,
            image: recipe.image,
            imageType: recipe.imageType,
            title: recipe.title,
            readyInMinutes: recipe.readyInMinutes,
            servings: recipe.servings,
            sourceUrl: recipe.sourceUrl,
            vegetarian: recipe.vegetarian,
            vegan: recipe.vegan,
            glutenFree: recipe.glutenFree,
            dairyFree: recipe.dairyFree,
            veryHealthy: recipe.veryHealthy,
            cheap: recipe.cheap,
            veryPopular: recipe.veryPopular,
            sustainable: recipe.sustainable,
            lowFodmap: recipe.lowFodmap,
            weightWatcherSmartPoints: recipe.weightWatcherSmartPoints,
            gaps: recipe.gaps,
            preparationMinutes: recipe.preparationMinutes,
            cookingMinutes: recipe.cookingMinutes,
            aggregateLikes: recipe.aggregateLikes,
            healthScore: recipe.healthScore,
            creditsText: recipe.creditsText,
            license: recipe.license,
            sourceName: recipe.sourceName,
            pricePerServing: recipe.pricePerServing,
            extendedIngredients: recipe.extendedIngredients,
            summary: recipe.summary.htmlStripped,
            generatedSummary: nil,
            cuisines: recipe.cuisines,
            dishTypes: recipe.dishTypes,
            diets: recipe.diets,
            occasions: recipe.occasions,
            instructions: recipe.instructions,
            analyzedInstructions: recipe.analyzedInstructions,
            originalId: recipe.originalId,
            spoonacularScore: recipe.spoonacularScore,
            spoonacularSourceUrl: recipe.spoonacularSourceUrl
        )
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
