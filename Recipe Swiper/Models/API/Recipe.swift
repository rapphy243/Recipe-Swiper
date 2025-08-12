//
//  Recipe.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/14/25.
//

//  Query decoded with Gemini 2.5 Pro

import Foundation
import FoundationModels

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

// MARK: - Recipe
// Represents a single recipe with its details.
class Recipe: ObservableObject, Codable, Hashable, Equatable {
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
    @Published var generatedSummary: String?

    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let occasions: [String]
    let instructions: String?
    let analyzedInstructions: [AnalyzedInstruction]
    let originalId: Int?
    let spoonacularScore: Double
    let spoonacularSourceUrl: String?

    init(
        id: Int,
        image: String?,
        imageType: String?,
        title: String,
        readyInMinutes: Int,
        servings: Int,
        sourceUrl: String?,
        vegetarian: Bool,
        vegan: Bool,
        glutenFree: Bool,
        dairyFree: Bool,
        veryHealthy: Bool,
        cheap: Bool,
        veryPopular: Bool,
        sustainable: Bool,
        lowFodmap: Bool,
        weightWatcherSmartPoints: Int,
        gaps: String,
        preparationMinutes: Int?,
        cookingMinutes: Int?,
        aggregateLikes: Int,
        healthScore: Int,
        creditsText: String,
        license: String?,
        sourceName: String,
        pricePerServing: Double,
        extendedIngredients: [ExtendedIngredient],
        summary: String,
        generatedSummary: String?,
        cuisines: [String],
        dishTypes: [String],
        diets: [String],
        occasions: [String],
        instructions: String?,
        analyzedInstructions: [AnalyzedInstruction],
        originalId: Int?,
        spoonacularScore: Double,
        spoonacularSourceUrl: String?
    ) {
        self.id = id
        self.image = image
        self.imageType = imageType
        self.title = title
        self.readyInMinutes = readyInMinutes
        self.servings = servings
        self.sourceUrl = sourceUrl
        self.vegetarian = vegetarian
        self.vegan = vegan
        self.glutenFree = glutenFree
        self.dairyFree = dairyFree
        self.veryHealthy = veryHealthy
        self.cheap = cheap
        self.veryPopular = veryPopular
        self.sustainable = sustainable
        self.lowFodmap = lowFodmap
        self.weightWatcherSmartPoints = weightWatcherSmartPoints
        self.gaps = gaps
        self.preparationMinutes = preparationMinutes
        self.cookingMinutes = cookingMinutes
        self.aggregateLikes = aggregateLikes
        self.healthScore = healthScore
        self.creditsText = creditsText
        self.license = license
        self.sourceName = sourceName
        self.pricePerServing = pricePerServing
        self.extendedIngredients = extendedIngredients
        self.summary = summary
        self.generatedSummary = nil
        self.cuisines = cuisines
        self.dishTypes = dishTypes
        self.diets = diets
        self.occasions = occasions
        self.instructions = instructions
        self.analyzedInstructions = analyzedInstructions
        self.originalId = originalId
        self.spoonacularScore = spoonacularScore
        self.spoonacularSourceUrl = spoonacularSourceUrl
    }

    // Manual Codable conformance is required for @Published properties
    enum CodingKeys: String, CodingKey {
        case id, image, imageType, title, readyInMinutes, servings, sourceUrl, vegetarian, vegan, glutenFree, dairyFree, veryHealthy, cheap, veryPopular, sustainable, lowFodmap, weightWatcherSmartPoints, gaps, preparationMinutes, cookingMinutes, aggregateLikes, healthScore, creditsText, license, sourceName, pricePerServing, extendedIngredients, summary, generatedSummary, cuisines, dishTypes, diets, occasions, instructions, analyzedInstructions, originalId, spoonacularScore, spoonacularSourceUrl
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let image = try container.decodeIfPresent(String.self, forKey: .image)
        let imageType = try container.decodeIfPresent(String.self, forKey: .imageType)
        let title = try container.decode(String.self, forKey: .title)
        let readyInMinutes = try container.decode(Int.self, forKey: .readyInMinutes)
        let servings = try container.decode(Int.self, forKey: .servings)
        let sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
        let vegetarian = try container.decode(Bool.self, forKey: .vegetarian)
        let vegan = try container.decode(Bool.self, forKey: .vegan)
        let glutenFree = try container.decode(Bool.self, forKey: .glutenFree)
        let dairyFree = try container.decode(Bool.self, forKey: .dairyFree)
        let veryHealthy = try container.decode(Bool.self, forKey: .veryHealthy)
        let cheap = try container.decode(Bool.self, forKey: .cheap)
        let veryPopular = try container.decode(Bool.self, forKey: .veryPopular)
        let sustainable = try container.decode(Bool.self, forKey: .sustainable)
        let lowFodmap = try container.decode(Bool.self, forKey: .lowFodmap)
        let weightWatcherSmartPoints = try container.decode(Int.self, forKey: .weightWatcherSmartPoints)
        let gaps = try container.decode(String.self, forKey: .gaps)
        let preparationMinutes = try container.decodeIfPresent(Int.self, forKey: .preparationMinutes)
        let cookingMinutes = try container.decodeIfPresent(Int.self, forKey: .cookingMinutes)
        let aggregateLikes = try container.decode(Int.self, forKey: .aggregateLikes)
        let healthScore = try container.decode(Int.self, forKey: .healthScore)
        let creditsText = try container.decode(String.self, forKey: .creditsText)
        let license = try container.decodeIfPresent(String.self, forKey: .license)
        let sourceName = try container.decode(String.self, forKey: .sourceName)
        let pricePerServing = try container.decode(Double.self, forKey: .pricePerServing)
        let extendedIngredients = try container.decode([ExtendedIngredient].self, forKey: .extendedIngredients)
        let summary = try container.decode(String.self, forKey: .summary)
        let generatedSummary: String? = nil
        let cuisines = try container.decode([String].self, forKey: .cuisines)
        let dishTypes = try container.decode([String].self, forKey: .dishTypes)
        let diets = try container.decode([String].self, forKey: .diets)
        let occasions = try container.decode([String].self, forKey: .occasions)
        let instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        let analyzedInstructions = try container.decode([AnalyzedInstruction].self, forKey: .analyzedInstructions)
        let originalId = try container.decodeIfPresent(Int.self, forKey: .originalId)
        let spoonacularScore = try container.decode(Double.self, forKey: .spoonacularScore)
        let spoonacularSourceUrl = try container.decodeIfPresent(String.self, forKey: .spoonacularSourceUrl)

        self.init(
            id: id,
            image: image,
            imageType: imageType,
            title: title,
            readyInMinutes: readyInMinutes,
            servings: servings,
            sourceUrl: sourceUrl,
            vegetarian: vegetarian,
            vegan: vegan,
            glutenFree: glutenFree,
            dairyFree: dairyFree,
            veryHealthy: veryHealthy,
            cheap: cheap,
            veryPopular: veryPopular,
            sustainable: sustainable,
            lowFodmap: lowFodmap,
            weightWatcherSmartPoints: weightWatcherSmartPoints,
            gaps: gaps,
            preparationMinutes: preparationMinutes,
            cookingMinutes: cookingMinutes,
            aggregateLikes: aggregateLikes,
            healthScore: healthScore,
            creditsText: creditsText,
            license: license,
            sourceName: sourceName,
            pricePerServing: pricePerServing,
            extendedIngredients: extendedIngredients,
            summary: summary,
            generatedSummary: generatedSummary,
            cuisines: cuisines,
            dishTypes: dishTypes,
            diets: diets,
            occasions: occasions,
            instructions: instructions,
            analyzedInstructions: analyzedInstructions,
            originalId: originalId,
            spoonacularScore: spoonacularScore,
            spoonacularSourceUrl: spoonacularSourceUrl
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(imageType, forKey: .imageType)
        try container.encode(title, forKey: .title)
        try container.encode(readyInMinutes, forKey: .readyInMinutes)
        try container.encode(servings, forKey: .servings)
        try container.encodeIfPresent(sourceUrl, forKey: .sourceUrl)
        try container.encode(vegetarian, forKey: .vegetarian)
        try container.encode(vegan, forKey: .vegan)
        try container.encode(glutenFree, forKey: .glutenFree)
        try container.encode(dairyFree, forKey: .dairyFree)
        try container.encode(veryHealthy, forKey: .veryHealthy)
        try container.encode(cheap, forKey: .cheap)
        try container.encode(veryPopular, forKey: .veryPopular)
        try container.encode(sustainable, forKey: .sustainable)
        try container.encode(lowFodmap, forKey: .lowFodmap)
        try container.encode(weightWatcherSmartPoints, forKey: .weightWatcherSmartPoints)
        try container.encode(gaps, forKey: .gaps)
        try container.encodeIfPresent(preparationMinutes, forKey: .preparationMinutes)
        try container.encodeIfPresent(cookingMinutes, forKey: .cookingMinutes)
        try container.encode(aggregateLikes, forKey: .aggregateLikes)
        try container.encode(healthScore, forKey: .healthScore)
        try container.encode(creditsText, forKey: .creditsText)
        try container.encodeIfPresent(license, forKey: .license)
        try container.encode(sourceName, forKey: .sourceName)
        try container.encode(pricePerServing, forKey: .pricePerServing)
        try container.encode(extendedIngredients, forKey: .extendedIngredients)
        try container.encode(summary, forKey: .summary)
        try container.encodeIfPresent(generatedSummary, forKey: .generatedSummary)
        try container.encode(cuisines, forKey: .cuisines)
        try container.encode(dishTypes, forKey: .dishTypes)
        try container.encode(diets, forKey: .diets)
        try container.encode(occasions, forKey: .occasions)
        try container.encodeIfPresent(instructions, forKey: .instructions)
        try container.encode(analyzedInstructions, forKey: .analyzedInstructions)
        try container.encodeIfPresent(originalId, forKey: .originalId)
        try container.encode(spoonacularScore, forKey: .spoonacularScore)
        try container.encodeIfPresent(spoonacularSourceUrl, forKey: .spoonacularSourceUrl)
    }

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
            "Orange Chocolate Cake requires approximately 45 minutes from start to finish. This recipe makes 12 servings with 247 calories, 4g of protein, and 14g of fat each. For 43 cents per serving, this recipe covers 5% of your daily requirements of vitamins and minerals. 95 people have made this recipe and would make it again. A mixture of semi-sweet chocolate, baking soda, flour, and a handful of other ingredients are all it takes to make this recipe so tasty. A few people really liked this dessert. It is brought to you by Foodista. Overall, this recipe earns a rather bad spoonacular score of 25%.",
        generatedSummary: "",
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
        generatedSummary: nil,
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
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Refrences https://superwall.com/blog/an-introduction-to-apples-foundation-model-framework
    // https://medium.com/@jaredcassoutt/building-an-ai-chatbot-with-apples-foundationmodels-framework-a-complete-swiftui-guide-de0347c0b18b#:~:text=Implementing%20Streaming%20AI%20Responses
    @MainActor
    func generateSummary() async throws {
        // Logic for devices without Apple Intelligence enabled
        guard SystemLanguageModel.default.isAvailable else {
            return
        }
        
        // Check if user enabled AI feature
        guard AppSettings.shared.enableAIFeatures && AppSettings.shared.aiRecipeSummary else {
            return
        }
        
        let instructions = Instructions(
            "Summarize the following food summary and remove any refrences to other recipes. Keep your language professional, avoiding informal language or unnecessary elaborations. Focus on delivering complete working solutions, providing logical explanations and using examples to support your responses. The generated summary should be simple and easy for the user to understand and remain in paragraph form. You can also talk about some general details about the recipe. Only include your generation, don't include follow up questions, intro, or ask the user anything. Just return the new generated summary only, don't say at the start ex. \"Here is the summary requested:\". The user will not be able to respond with you. At the end of the summary add text that the summary was generated by \"Generated by Snack Swipe\""
        )
        let session = LanguageModelSession(instructions: instructions)
        let prompt = Prompt(self.summary)

        let stream = session.streamResponse(to: prompt)
        for try await response in stream {
            print(response)
            self.generatedSummary = response.content
        }
    }
}
