//
//  API.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/14/25.
//
// Generated with Gemini 2.5 Pro Prompt: "I want to create a function that returns the recipe from the API"

import Foundation
import SwiftUI

// Claude 3.5 Prompt: "I want to know how many api requests I have left. This is from the documentation..."
class APIQuota: ObservableObject {
    static let shared = APIQuota() // Singleton instance
    
    @AppStorage("quotaRequest") private(set) var quotaRequest: Double = 0  // Points used by last request
    @AppStorage("quotaUsed") private(set) var quotaUsed: Double = 0    // Total points used today
    @AppStorage("quotaLeft") private(set) var quotaLeft: Double = 0    // Points remaining today
    
    private init() {} // Private initializer for singleton
    
    func updateQuota(from headers: [AnyHashable: Any]) {
        if let requestQuota = headers["x-api-quota-request"] as? String,
           let requestValue = Double(requestQuota) {
            quotaRequest = requestValue
        }
        
        if let usedQuota = headers["x-api-quota-used"] as? String,
           let usedValue = Double(usedQuota) {
            quotaUsed = usedValue
        }
        
        if let leftQuota = headers["x-api-quota-left"] as? String,
           let leftValue = Double(leftQuota) {
            quotaLeft = leftValue
        }
        
        // Debug print to verify values are updating
//        print("Updated quota - Request: \(quotaRequest), Used: \(quotaUsed), Left: \(quotaLeft)")
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

func fetchRandomRecipe(using filterModel: FilterModel) async throws -> Recipe {

    var components = URLComponents(
        string: "https://api.spoonacular.com/recipes/random"
    )!
    components.queryItems = filterModel.queryItems(apiKey: Secrets.apiKey)
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
        
        // Debug print to see all headers
//        print("All response headers:")
//        httpResponse.allHeaderFields.forEach { key, value in
//            print("\(key): \(value)")
//        }
        
        // Update quota information from response headers
        APIQuota.shared.updateQuota(from: httpResponse.allHeaderFields)
        
        print("Received HTTP status code: \(httpResponse.statusCode)")  // Debugging
        print("API Quota remaining: \(APIQuota.shared.quotaLeft)")      // Debugging quota

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

// Recipe.summary sometime has html tags, so we should get rid of them
func removeHTMLTagsRegex(from htmlString: String) -> String {
    // The regular expression pattern "<.*?>" matches:
    // <   : The opening angle bracket
    // .   : Any character (except newline)
    // *   : Zero or more times
    // ?   : Makes the '*' non-greedy (matches the shortest possible sequence)
    // >   : The closing angle bracket
    let pattern = "<.*?>"

    // Use String's built-in method for replacing regex matches
    return htmlString.replacingOccurrences(
        of: pattern,
        with: "",
        options: [.regularExpression],
        range: nil  // Apply to the entire string
    )
}

func getPrefixBefore(phrase: String, in originalString: String) -> String {
    // Handle empty phrase: return the original string as there's nothing to stop at.
    guard !phrase.isEmpty else {
        return originalString
    }

    // Find the range (location) of the first occurrence of the phrase.
    // This is case-sensitive by default.
    if let range = originalString.range(of: phrase) {
        // If the phrase is found, get the part of the string *before*
        // the phrase starts (up to its lowerBound).
        let prefix = originalString[..<range.lowerBound]
        return String(prefix)  // Convert the Substring slice back to a String
    } else {
        // If the phrase is not found, return the whole original string.
        return originalString
    }
}

func simplifySummary(_ summary: String) -> String {
    var strippedSummary = removeHTMLTagsRegex(from: summary)
    strippedSummary = getPrefixBefore(
        phrase: "It is brought to ",
        in: strippedSummary
    )
    strippedSummary = getPrefixBefore(
        phrase: "If you like this ",
        in: strippedSummary
    )
    return strippedSummary
}
