//
//  RecipeModel.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//
//  Generated with Claude 3.5 Sonnet

import Foundation
import SwiftData
import SwiftUI

@Model
final class RecipeModel {
    // Used for sorting
    var isDiscarded: Bool  // if saved show in savedItems, if not show in discardedItems
    var dateModified: Date  // sort by date added/modified
    //
    var rating: Int
    @Attribute(.unique)
    var id: Int
    var image: String?
    @Attribute(.externalStorage)
    var imageData: Data?
    var imageType: String?
    var title: String
    var readyInMinutes: Int
    var servings: Int
    var sourceUrl: String?
    var vegetarian: Bool
    var vegan: Bool
    var glutenFree: Bool
    var dairyFree: Bool
    var veryHealthy: Bool
    var cheap: Bool
    var preparationMinutes: Int?
    var cookingMinutes: Int?
    var healthScore: Int
    var creditsText: String
    var license: String?
    var sourceName: String
    var pricePerServing: Double
    @Relationship(deleteRule: .cascade)
    var extendedIngredients: [ExtendedIngredientModel]
    var summary: String
    // These String arrays cause "Could not materialize Objective-C class named "Array" from declared attribute value type "Array<String>" of attribute named"
    // SwiftData/CoreData doest not support arrays of strings, but it converts it to data to store it and then decodes it back to an array of strings.
    var cuisines: [String]
    var dishTypes: [String]
    var diets: [String]
    var occasions: [String]
    //
    var instructions: String?
    @Relationship(deleteRule: .cascade)
    var analyzedInstructions: [AnalyzedInstructionModel]
    var originalId: Int?
    var spoonacularScore: Double
    var spoonacularSourceUrl: String?

    init(from recipe: Recipe, isDiscarded: Bool = false) {
        //
        self.isDiscarded = isDiscarded
        self.dateModified = Date()
        //
        self.rating = 0
        self.id = recipe.id
        self.image = recipe.image
        self.imageType = recipe.imageType
        self.title = recipe.title
        self.readyInMinutes = recipe.readyInMinutes
        self.servings = recipe.servings
        self.sourceUrl = recipe.sourceUrl
        self.vegetarian = recipe.vegetarian
        self.vegan = recipe.vegan
        self.glutenFree = recipe.glutenFree
        self.dairyFree = recipe.dairyFree
        self.veryHealthy = recipe.veryHealthy
        self.cheap = recipe.cheap
        self.preparationMinutes = recipe.preparationMinutes
        self.cookingMinutes = recipe.cookingMinutes
        self.healthScore = recipe.healthScore
        self.creditsText = recipe.creditsText
        self.license = recipe.license
        self.sourceName = recipe.sourceName
        self.pricePerServing = recipe.pricePerServing
        self.extendedIngredients = recipe.extendedIngredients.map(ExtendedIngredientModel.init)
        self.summary = recipe.summary
        self.cuisines = recipe.cuisines
        self.dishTypes = recipe.dishTypes
        self.diets = recipe.diets
        self.occasions = recipe.occasions
        self.instructions = recipe.instructions
        self.analyzedInstructions = recipe.analyzedInstructions.map(AnalyzedInstructionModel.init)
        self.originalId = recipe.originalId
        self.spoonacularScore = recipe.spoonacularScore
        self.spoonacularSourceUrl = recipe.spoonacularSourceUrl
    }

    final func getImage() async -> UIImage? {  // Decode Image Data to a UIImage that can be displayed
        if let imageData = self.imageData {
            return UIImage(data: imageData)
        }
        else if let imageString = self.image {
            let imageUrl = URL(string: imageString)
            do {
                // Perform asynchronous download
                let (data, response) = try await URLSession.shared.data(
                    from: imageUrl!)

                // Basic check for valid HTTP response
                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                {
                    self.imageData = data
                    return UIImage(data: data)
                } else {
                    print(
                        "Warning: Received non-200 response for image URL: \(imageString)"
                    )
                }
            } catch {
                print(
                    "Error downloading image from \(imageString): \(error.localizedDescription)"
                )
                // imageData remains nil
            }
        }
        print("Warning: Recipe \(self.id) has no valid image URL.")
        return nil
    }
}
