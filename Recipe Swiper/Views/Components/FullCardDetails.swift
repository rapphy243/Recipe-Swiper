//
//  CardDetails.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/19/25.
//

import SwiftUI

struct FullCardDetails: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable var recipe: RecipeModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                HStack {
                    // Source of Recipe
                    Image(systemName: "book.closed.fill")
                    if recipe.sourceUrl != "" {
                        Link(destination: URL(string: recipe.sourceUrl)!) {
                            Text("\(getHostURL(recipe.sourceUrl))")
                                .font(.footnote)
                                .foregroundColor(
                                    colorScheme == .dark ? .white : .black
                                )
                        }
                    } else {
                        Text("No Source")
                            .font(.footnote)
                    }
                }
                Divider()
                    .frame(maxHeight: 30)
                HStack {
                    // How long to make
                    Image(systemName: "timer")
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(recipe.readyInMinutes)min")
                            .font(.footnote)
                        Text("Total")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Divider()
                    .frame(maxHeight: 30)
                // Amount of servings
                HStack {
                    Image(systemName: "person.2.fill")
                    Text("\(recipe.servings)")
                        .font(.footnote)
                }
                Divider()
                    .frame(maxHeight: 30)
                // Health Score
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(healthScoreColor)
                    Text("\(recipe.healthScore)")
                        .font(.footnote)
                }
            }
            HStack(spacing: 10) {
                if !recipe.cuisines.isEmpty {
                    // List of regions recipe is from
                    HStack(spacing: 5) {
                        Image(systemName: "globe")
                        Text(recipe.cuisines.joined(separator: ", ").capitalized)
                            .font(.footnote)
                    }
                }
                // Vegan indicator
                if recipe.vegan {
                    Text("VG")
                        .font(.caption)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.green.opacity(0.2))
                        .cornerRadius(4)
                }
                // Vegetarian indicator
                if recipe.vegetarian {
                    Text("V")
                        .font(.caption)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.green.opacity(0.4))
                        .cornerRadius(4)
                }
                // Gluten free indicator
                if recipe.glutenFree {
                    Text("GF")
                        .font(.caption)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.brown.opacity(0.4))
                        .cornerRadius(4)
                }
                // Dairy free indicator
                if recipe.dairyFree {
                    Text("DF")
                        .font(.caption)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.blue.opacity(0.2))
                        .cornerRadius(4)
                }
            }
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
    
    // Simple, but kind of bad way to get only the host of a url (www.google.com -> google.com)
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

#Preview {
    @Previewable @State var recipe = RecipeModel(from: loadCurryRecipe())
    FullCardDetails(recipe: recipe)
}
