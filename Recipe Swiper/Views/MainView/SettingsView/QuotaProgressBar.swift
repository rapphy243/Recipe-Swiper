//
//  QuotaProgressBar.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/2/25.
//

import SwiftUI

struct QuotaProgressBar: View {
    @EnvironmentObject var quota: APIQuota
    var body: some View {
        GeometryReader { geometry in  // allows us toaccess and manipulate size and position of view
            ZStack(alignment: .leading) {
                // Empty progress bar
                Rectangle()
                    .frame(
                        width: geometry.size.width,  // Get with of view
                        height: 20
                    )
                    .opacity(0.3)
                    .foregroundColor(.gray)
                // Actual progress to max quota
                Rectangle()
                    .frame(
                        width: calculateProgressWidth(
                            totalWidth: geometry.size.width
                        ),
                        height: 20
                    )
                    .foregroundColor(
                        getProgressColor(
                            used: quota.quotaUsed,
                            total: quota.quotaUsed
                                + quota.quotaLeft
                        )
                    )
            }
            .cornerRadius(10)
        }
        .frame(height: 20)
        .padding(.vertical, 8)
    }
    private func calculateProgressWidth(totalWidth: CGFloat) -> CGFloat {
        let total = quota.quotaUsed + quota.quotaLeft
        guard total > 0 else { return 0 }  // Prevent division by zero

        let ratio = quota.quotaUsed / total
        return totalWidth * CGFloat(ratio)
    }

    private func getProgressColor(used: Double, total: Double) -> Color {
        guard total > 0 else { return .green }  // Default color when no data
        let percentage = used / total
        switch percentage {
        case 0..<0.6:
            return .green
        case 0.6..<0.8:
            return .yellow
        default:
            return .red
        }
    }
}

#Preview {
    List {
        QuotaProgressBar()
            .environmentObject(APIQuota.shared)
    }
}
