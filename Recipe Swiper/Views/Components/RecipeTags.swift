//
//  RecipeTags.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/24/25.
//

import SwiftUI

struct TimeTag: View {
    var minutes: Int
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "timer")
            VStack(alignment: .leading, spacing: 0) {
                Text("\(minutes)min")
                    .font(.footnote)
                Text("Total")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ServingsTag: View {
    var servings: Int
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "person.2.fill")
            Text("\(servings)")
                .font(.footnote)
        }
    }
}
struct SourceTag: View {
    @Environment(\.colorScheme) private var colorScheme
    var source: String
    var body: some View {
        HStack {
            Image(systemName: "book.closed.fill")
            if source == "" {
                Text("No Source")
                    .font(.footnote)
                    .foregroundColor(
                        colorScheme == .dark ? .white : .black
                    )
            } else {
                if let url = URL(string: source), let host = url.host {
                    let displayHost =
                        host.hasPrefix("www.")
                        ? String(host.dropFirst(4)) : host
                    Link(destination: url) {
                        Text(displayHost)
                            .font(.footnote)
                            .foregroundColor(
                                colorScheme == .dark ? .white : .black
                            )
                    }
                } else {
                    Text("Invalid Source")
                        .font(.footnote)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
        }
    }
}

struct HealthTag: View {
    var healthScore: Int
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "heart.fill")
                .foregroundColor(healthScoreColor)
            Text("\(healthScore)")
                .font(.footnote)
        }
    }

    private var healthScoreColor: Color {
        switch healthScore {
        case 80...100: return .green
        case 60..<80: return .yellow
        case 40..<60: return .orange
        default: return .red
        }
    }
}
struct VegetarianTag: View {
    var body: some View {
        Text("VE")
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.green.opacity(0.15))
            .cornerRadius(4)
    }
}

struct VeganTag: View {
    var body: some View {
        Text("VG")
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.green.opacity(0.2))
            .cornerRadius(4)
    }
}

struct GlutenFreeTag: View {
    var body: some View {
        Text("GF")
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.brown.opacity(0.4))
            .cornerRadius(4)
    }
}

struct DairyFreeTag: View {
    var body: some View {
        Text("DF")
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(4)
    }
}

struct CuisineTags: View {
    let cuisines: [String]
    let showAll: Bool?
    var body: some View {
        if !cuisines.isEmpty {
            HStack(spacing: 5) {
                Image(systemName: "globe")
                if showAll ?? false {
                    Text(cuisines.joined(separator: ", ").capitalized)
                        .font(.footnote)
                } else {
                    Text(cuisines[0].capitalized)
                        .font(.footnote)

                }
            }
        }
    }
}

#Preview {
    VStack {
        TimeTag(minutes: 10)
        ServingsTag(servings: 5)
        HealthTag(healthScore: 100)
        SourceTag(source: "https://www.example.com")
        VegetarianTag()
        VeganTag()
        GlutenFreeTag()
        DairyFreeTag()
        CuisineTags(
            cuisines: ["Chinese", "Italian", "Indian", "American"],
            showAll: true
        )
    }
}
