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
    var body: some View {
        //Generate a long rounded save button
        List {
            Button("Restart Onboarding") {
                isOnboarding = true
            }
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
            Section(header: Text("Food Prefrences")) {
            }
            Section(header: Text("Backend Settings")) {
                HStack {
                    Text("API Key:")
                    Spacer()
                    TextField(Secrets.apiKey, text: $apiKey)
                        .onChange(of: apiKey) {
                            Secrets.setApiKey(apiKey)
                        }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
