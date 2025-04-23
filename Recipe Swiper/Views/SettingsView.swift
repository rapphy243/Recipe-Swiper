//
//  SettingsView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/22/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var apiKey: String = Secrets.apiKey
    
    let foodTypes = ["No Peanuts",]
    var body: some View {
        List {
            Section(header: Text("Other Settings")) {
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
    }
}

#Preview {
    SettingsView()
}
