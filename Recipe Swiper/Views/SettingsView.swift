//
//  SettingsView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/22/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var apiKey: String = Secrets.apiKey
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Other")) {
                    HStack {
                        Text("Spoonacular API Key:")
                            .lineLimit(1)
                            .fixedSize()
                        Spacer()
                        TextField(Secrets.apiKey, text: $apiKey)
                            .onChange(of: apiKey) {
                                Secrets.setApiKey(apiKey)
                            }
                    }
                }
                Button("Restart Onboarding") {
                    isOnboarding = true
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
