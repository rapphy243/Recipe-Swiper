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
    var rating: Double
    @Attribute(.unique)
    var id: Int
    var image: String
    @Attribute(.externalStorage)
    var imageData: Data?
    var imageType: String?
    var title: String
    var readyInMinutes: Int
    var servings: Int
    var sourceUrl: String
    var vegetarian: Bool
    var vegan: Bool
    var glutenFree: Bool
    var dairyFree: Bool
    var veryHealthy: Bool
    var cheap: Bool
    var preparationMinutes: Int
    var cookingMinutes: Int
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
    @Attribute(.externalStorage)
    private var cuisinesData: Data?
    @Attribute(.externalStorage)
    private var dishTypesData: Data?
    @Attribute(.externalStorage)
    private var dietsData: Data?
    @Attribute(.externalStorage)
    private var occasionsData: Data?
    //
    var cuisines: [String] {
        get { getStringArray(from: cuisinesData) ?? [] }
        set { cuisinesData = encodeStringArray(newValue) }
    }
    var dishTypes: [String] {
        get { getStringArray(from: dishTypesData) ?? [] }
        set { dishTypesData = encodeStringArray(newValue) }
    }
    var diets: [String] {
        get { getStringArray(from: dietsData) ?? [] }
        set { dietsData = encodeStringArray(newValue) }
    }
    var occasions: [String] {
        get { getStringArray(from: occasionsData) ?? [] }
        set { occasionsData = encodeStringArray(newValue) }
    }
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
        self.rating = 0.0  // Initialize as Double
        self.id = recipe.id
        self.image = recipe.image ?? ""
        self.imageData = nil
        self.imageType = recipe.imageType
        self.title = recipe.title
        self.readyInMinutes = recipe.readyInMinutes
        self.servings = recipe.servings
        self.sourceUrl = recipe.sourceUrl ?? ""
        self.vegetarian = recipe.vegetarian
        self.vegan = recipe.vegan
        self.glutenFree = recipe.glutenFree
        self.dairyFree = recipe.dairyFree
        self.veryHealthy = recipe.veryHealthy
        self.cheap = recipe.cheap
        self.preparationMinutes = recipe.preparationMinutes ?? 0
        self.cookingMinutes = recipe.cookingMinutes ?? 0
        self.healthScore = recipe.healthScore
        self.creditsText = recipe.creditsText
        self.license = recipe.license
        self.sourceName = recipe.sourceName
        self.pricePerServing = recipe.pricePerServing
        self.extendedIngredients = recipe.extendedIngredients.map(
            ExtendedIngredientModel.init
        )
        self.summary = simplifySummary(recipe.summary)
        self.cuisinesData = try? JSONEncoder().encode(recipe.cuisines)
        self.dishTypesData = try? JSONEncoder().encode(recipe.dishTypes)
        self.dietsData = try? JSONEncoder().encode(recipe.diets)
        self.occasionsData = try? JSONEncoder().encode(recipe.occasions)
        self.instructions = recipe.instructions
        self.analyzedInstructions = recipe.analyzedInstructions.map(
            AnalyzedInstructionModel.init
        )
        self.originalId = recipe.originalId
        self.spoonacularScore = recipe.spoonacularScore
        self.spoonacularSourceUrl = recipe.spoonacularSourceUrl
        Task {
            await fetchImage()
        }
    }

    final func getImage() async -> UIImage? {
        // Return cached image if available
        if let imageData = self.imageData {
            return UIImage(data: imageData)
        }

        // if we don't have a URL
        if self.image == "" {
            return nil
        }

        let imageUrl = URL(string: self.image)

        do {
            let (data, response) = try await URLSession.shared.data(
                from: imageUrl!
            )

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                print("Error: Invalid response for image URL: \(self.image)")
                return nil
            }

            // Store data in the model
            self.imageData = data
            return UIImage(data: data)
        } catch {
            print("Error downloading image: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func fetchImage() async {
        let imageUrl = URL(string: self.image)
        do {
            let (data, response) = try await URLSession.shared.data(
                from: imageUrl!
            )
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                print("Error: Invalid response for image URL: \(self.image)")
                return
            }
            // Store data in the model
            self.imageData = data
        } catch {
            print("Error downloading image: \(error.localizedDescription)")
        }
    }
    // Helper methods for conversion
    private func encodeStringArray(_ array: [String]) -> Data? {
        try? JSONEncoder().encode(array)
    }

    private func getStringArray(from data: Data?) -> [String]? {
        guard let data = data else {
            return nil
        }
        return try? JSONDecoder().decode([String].self, from: data)
    }
}
