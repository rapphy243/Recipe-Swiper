//
//  SettingsView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/2/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var apiKey: String = ""
    @ObservedObject private var quota = APIQuota.shared

    var body: some View {
        NavigationStack {
            List {
                Section("API Usage") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Daily Quota Usage")
                            Spacer()
                            Text(
                                "\(Int(quota.quotaUsed))/\(Int(quota.quotaUsed + quota.quotaLeft)) points"
                            )
                        }
                        QuotaProgressBar()
                            .environmentObject(quota)
                        HStack {
                            Text("Last Request:")
                            Spacer()
                            Text("\(Int(quota.quotaRequest)) points")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Section(header: Text("Other")) {
                    HStack {
                        Text("Spoonacular API Key:")
                            .lineLimit(1)
                            .fixedSize()
                        Spacer()
                        TextField(Env.apiKey, text: $apiKey)
                            .onChange(of: apiKey) {
                                UserDefaults.standard.set(apiKey, forKey: "apiKey")
                            }
                    }
                }
                Button("Restart Onboarding") {
                    UserDefaults.standard.set(true, forKey: "isOnboarding")
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
