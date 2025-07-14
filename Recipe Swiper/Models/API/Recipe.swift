//
//  Recipe.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/14/25.
//

//  Query decoded with Gemini 2.5 Pro

import Foundation

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

// MARK: - Recipe
// Represents a single recipe with its details.
struct Recipe: Codable, Hashable, Equatable {
    let id: Int
    let image: String?
    let imageType: String?
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String?
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    let veryPopular: Bool
    let sustainable: Bool
    let lowFodmap: Bool
    let weightWatcherSmartPoints: Int
    let gaps: String
    let preparationMinutes: Int?
    let cookingMinutes: Int?
    let aggregateLikes: Int
    let healthScore: Int
    let creditsText: String
    let license: String?
    let sourceName: String
    let pricePerServing: Double
    let extendedIngredients: [ExtendedIngredient]
    let summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let occasions: [String]
    let instructions: String?
    let analyzedInstructions: [AnalyzedInstruction]
    let originalId: Int?
    let spoonacularScore: Double
    let spoonacularSourceUrl: String?

    static let Cake = Recipe(
        id: 653836,
        image: "https://img.spoonacular.com/recipes/653836-556x370.jpg",
        imageType: "jpg",
        title: "Orange Chocolate Cake",
        readyInMinutes: 45,
        servings: 12,
        sourceUrl:
            "https://www.foodista.com/recipe/6RW2HBQM/orange-chocolate-cake",
        vegetarian: false,
        vegan: false,
        glutenFree: false,
        dairyFree: false,
        veryHealthy: false,
        cheap: false,
        veryPopular: false,
        sustainable: false,
        lowFodmap: false,
        weightWatcherSmartPoints: 10,
        gaps: "no",
        preparationMinutes: nil,
        cookingMinutes: nil,
        aggregateLikes: 95,
        healthScore: 1,
        creditsText:
            "Foodista.com – The Cooking Encyclopedia Everyone Can Edit",
        license: "CC BY 3.0",
        sourceName: "Foodista",
        pricePerServing: 43.19,
        extendedIngredients: [],
        summary:
            "Orange Chocolate Cake requires approximately 45 minutes from start to finish. This recipe makes 12 servings with 247 calories, 4g of protein, and 14g of fat each. For 43 cents per serving, this recipe covers 5% of your daily requirements of vitamins and minerals. 95 people have made this recipe and would make it again. A mixture of semi-sweet chocolate, baking soda, flour, and a handful of other ingredients are all it takes to make this recipe so tasty. A few people really liked this dessert. It is brought to you by Foodista. Overall, this recipe earns a rather bad spoonacular score of 25%. If you like this recipe, take a look at these similar recipes: <a href=\"https://spoonacular.com/recipes/orange-scented-bittersweet-chocolate-cake-with-candied-blood-orange-compote-51335\">Orange-Scented Bittersweet Chocolate Cake with Candied Blood Orange Compote</a>, <a href=\"https://spoonacular.com/recipes/wacky-chocolate-orange-cake-with-orange-frosting-131847\">Wacky Chocolate-Orange Cake with Orange Frosting</a>, and <a href=\"https://spoonacular.com/recipes/chocolate-orange-protein-cake-with-chocolate-icing-558609\">Chocolate Orange Protein Cake with Chocolate Icing</a>.",
        cuisines: [],
        dishTypes: ["dessert"],
        diets: [],
        occasions: [],
        instructions:
            "Preheat oven at 175C, Grease a 9 inch bundt pan, and dust flour or spray non-stick spray in pan. Beat butter for a while and add in sugar, continue to beat butter until creamy. Add eggs one at a time and mix well. Add orange rind, orange juice and vanilla extract, beat at low speed till well combined. Split ingredient (B) into 4 portions and sour cream into 3 portions. Pour in one portion of flour and sour cream alternately, beat well after each addition. Take half of the mixture and gently mix with melted chocolate (do not over mix). Scoop plain and chocolate batter alternately into pan, till all the batters are used up and gently shake the pan a little. Bake for 50-60 minutes or skewer comes out clean. Remove cake from oven and set to cool for 20 minutes then unmould, leave to cool completely.",
        analyzedInstructions: [],
        originalId: nil,
        spoonacularScore: 33.852783203125,
        spoonacularSourceUrl:
            "https://spoonacular.com/orange-chocolate-cake-653836"
    )

    static let empty = Recipe(
        id: -1,
        image: "https://picsum.photos/200/300",  // Returns a random image, used to make sure Persistence Model doesn't try to get a null image
        imageType: "",
        title: "Not Found",
        readyInMinutes: 0,
        servings: 0,
        sourceUrl: nil,
        vegetarian: false,
        vegan: false,
        glutenFree: false,
        dairyFree: false,
        veryHealthy: false,
        cheap: false,
        veryPopular: false,
        sustainable: false,
        lowFodmap: false,
        weightWatcherSmartPoints: 0,
        gaps: "",
        preparationMinutes: nil,
        cookingMinutes: nil,
        aggregateLikes: 0,
        healthScore: 0,
        creditsText: "",
        license: nil,
        sourceName: "",
        pricePerServing: 0.0,
        extendedIngredients: [],
        summary: "Recipe data could not be loaded.",
        cuisines: [],
        dishTypes: [],
        diets: [],
        occasions: [],
        instructions: nil,
        analyzedInstructions: [],
        originalId: nil,
        spoonacularScore: 0.0,
        spoonacularSourceUrl: nil
    )

}
