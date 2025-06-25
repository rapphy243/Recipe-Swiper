//
//  SettingsView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/22/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var apiKey: String = ""
    
    var body: some View {
        List {
            Section(header: Text("API Usage")) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Daily Quota Usage")
                        Spacer()
                        Text(
                            "\(Int(1))/\(Int(1 + 100)) points"
                        )
                    }

                    .frame(height: 20)
                    .padding(.bottom, 8)

                    // Last request info
                    HStack {
                        Text("Last Request:")
                        Spacer()
                        Text("\(Int(0)) points")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }

            Section(header: Text("Other")) {
                HStack {
                    Text("Spoonacular API Key:")
                        .lineLimit(1)
                        .fixedSize()
                    Spacer()
                    TextField(apiKey, text: .constant("asda"))
                        .onChange(of: apiKey) {

                        }
                }
            }
            Button("Restart Onboarding") {
                isOnboarding = true
            }
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
#Preview {
    SettingsView()
}
