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
            HStack(spacing: 10) {
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
            HStack(spacing: 10) {
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
                        }
                    } else {
                        Text("No Source")
                            .font(.footnote)
                    }
                    // Health score provided by Spoonacular
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(healthScoreColor)
                        Text("\(recipe.healthScore)")
                            .font(.footnote)
                    }
                }
            }
            HStack(spacing: 10) {
                // Show cuisine recipe is from and if it is vegan or gluten free
                if !recipe.cuisines.isEmpty {
                    HStack(spacing: 5) {
                        Image(systemName: "globe")
                        Text(recipe.cuisines[0].capitalized)
                            .font(.footnote)
                    }
                    if recipe.vegan {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                    }
                    if recipe.glutenFree {
                        Text("GF")
                            .font(.caption)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(.green.opacity(0.2))
                            .cornerRadius(4)
                    }
                } else {  // if cusisine doesn't exist show vegan, gluten free, or dairy free (width)
                    if recipe.vegan {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                    }
                    if recipe.glutenFree {
                        Text("GF")
                            .font(.caption)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(.green.opacity(0.2))
                            .cornerRadius(4)
                    }
                    if recipe.dairyFree {
                        Text("DF")
                            .font(.caption)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(.green.opacity(0.2))
                            .cornerRadius(4)
                            .background(.blue.opacity(0.2))
                    }
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

#Preview {
    SmallCardDetails(recipe: loadCakeRecipe())
}
