//
//  CardDetails.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/19/25.
//

import SwiftUI

struct SmallCardDetails: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var recipe: Recipe
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TimeAndServingsView(recipe: recipe)
            SourceAndHealthScoreView(recipe: recipe, colorScheme: colorScheme)
            CuisineAndDietaryTagsView(recipe: recipe)
        }
        .padding()
        .cornerRadius(8)
    }

    // color for health score
    private var healthScoreColor: Color {
        switch recipe.healthScore {
        case 80...100: return .green
        case 60..<80: return .yellow
        case 40..<60: return .orange
        default: return .red
        }
    }

    // Takes a URL and returns the host of it (www.google.com -> google.com)
    // This is not a really good solution to get the host, but it is simple enough to mostly work
    private func getHostURL(_ urlString: String) -> String {
        guard let url = URL(string: urlString), let host = url.host,
            !host.isEmpty
        else {
            return "No Source"  // Invalid URL or no host
        }

        //Sometimes the url has www.*, so we want to remove it
        let components = host.split(separator: ".")

        // Handle different numbers of components
        if components.count >= 2 {
            // If 2 or more parts, take the last two and join them
            return components.suffix(2).joined(separator: ".")
        } else if components.count == 1 {
            // If only 1 part (like "localhost"), return it directly
            return String(components[0])
        } else {
            // Should not happen if host is not empty, but handle defensively
            return "No Source"
        }
    }
}

private struct TimeAndServingsView: View {
    let recipe: Recipe

    var body: some View {
        ViewThatFits {
            HStack(spacing: 10) {
                content
            }
            VStack(alignment: .leading, spacing: 5) {  // Fallback VStack
                content
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        HStack(spacing: 5) {
            // Time to make
            Image(systemName: "timer")
            VStack(alignment: .leading, spacing: 0) {
                Text("\(recipe.readyInMinutes)min")
                    .font(.footnote)
                Text("Total")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        // How many servings
        HStack(spacing: 2) {
            Image(systemName: "person.2.fill")
            Text("\(recipe.servings)")
                .font(.footnote)
        }
    }
}

private struct SourceAndHealthScoreView: View {
    let recipe: Recipe
    let colorScheme: ColorScheme

    var body: some View {
        ViewThatFits {
            HStack(spacing: 10) {
                content
            }
            VStack(alignment: .leading, spacing: 5) {  // Fallback VStack
                content
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        // Source of recipe
        HStack {
            Image(systemName: "book.closed.fill")
            if let hosturl = recipe.sourceUrl {
                Link(destination: URL(string: hosturl)!) {
                    Text("\(getHostURL(hosturl))")
                        .font(.footnote)
                        .foregroundColor(
                            colorScheme == .dark ? .white : .black
                        )
                        .fixedSize(horizontal: false, vertical: true)
                }
            } else {
                Text("No Source")
                    .font(.footnote)
            }
        }
        // Health score provided by Spoonacular
        HStack(spacing: 4) {
            Image(systemName: "heart.fill")
                .foregroundColor(healthScoreColor)
            Text("\(recipe.healthScore)")
                .font(.footnote)
        }
    }

    // color for health score (copied from SmallCardDetails)
    private var healthScoreColor: Color {
        switch recipe.healthScore {
        case 80...100: return .green
        case 60..<80: return .yellow
        case 40..<60: return .orange
        default: return .red
        }
    }

    // getHostURL function (copied from SmallCardDetails)
    private func getHostURL(_ urlString: String) -> String {
        guard let url = URL(string: urlString), let host = url.host,
            !host.isEmpty
        else {
            return "No Source"
        }
        let components = host.split(separator: ".")
        if components.count >= 2 {
            return components.suffix(2).joined(separator: ".")
        } else if components.count == 1 {
            return String(components[0])
        } else {
            return "No Source"
        }
    }
}

private struct CuisineAndDietaryTagsView: View {
    let recipe: Recipe

    var body: some View {
        ViewThatFits {
            HStack(spacing: 10) {
                cuisineAndTags
            }
            VStack(alignment: .leading, spacing: 5) {  // Fallback VStack for cuisine and tags
                cuisineSection
                dietaryTagsSection  // For vertical stacking of tags
            }
        }
    }

    @ViewBuilder
    private var cuisineAndTags: some View {
        if !recipe.cuisines.isEmpty {
            HStack(spacing: 5) {
                Image(systemName: "globe")
                Text(recipe.cuisines[0].capitalized)
                    .font(.footnote)
            }
            if recipe.vegan {
                veganTag
            }
            if recipe.glutenFree {
                glutenFreeTagGreen
            }
        } else {
            if recipe.vegan {
                veganTag
            }
            if recipe.glutenFree {
                glutenFreeTagBrown  // Brown when no cuisine
            }
            if recipe.dairyFree {
                dairyFreeTag
            }
        }
    }

    @ViewBuilder
    private var cuisineSection: some View {
        if !recipe.cuisines.isEmpty {
            HStack(spacing: 5) {
                Image(systemName: "globe")
                Text(recipe.cuisines[0].capitalized)
                    .font(.footnote)
            }
        }
    }

    @ViewBuilder
    private var dietaryTagsSection: some View {
        HStack {  // Group tags for consistent horizontal layout in fallback
            if !recipe.cuisines.isEmpty {
                if recipe.vegan {
                    veganTag
                }
                if recipe.glutenFree {
                    glutenFreeTagGreen
                }
            } else {
                if recipe.vegan {
                    veganTag
                }
                if recipe.glutenFree {
                    glutenFreeTagBrown
                }
                if recipe.dairyFree {
                    dairyFreeTag
                }
            }
        }
    }

    private var veganTag: some View {
        Text("VG")
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.green.opacity(0.2))
            .cornerRadius(4)
    }

    private var glutenFreeTagGreen: some View {
        Text("GF")
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.green.opacity(0.2))
            .cornerRadius(4)
    }

    private var glutenFreeTagBrown: some View {
        Text("GF")
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.brown.opacity(0.4))
            .cornerRadius(4)
    }

    private var dairyFreeTag: some View {
        Text("DF")
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(4)
    }
}

#Preview {
    SmallCardDetails(recipe: loadSaladRecipe())
}
#Preview {
    SmallRecipeCard(recipe: loadSaladRecipe())
}
