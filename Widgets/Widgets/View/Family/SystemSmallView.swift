//
//  SmallView.swift
//  News
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import DesignSystem
import Foundation
import LocalizationKit
import SwiftUI

struct SystemSmallView: View {
    let entry: Provider.Entry

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VerStack {
            categoryWithIndicator
            Spacer()
            level
            Spacer()
            progress
        }
        .padding(14)
    }

    @ViewBuilder
    var categoryWithIndicator: some View {
        let color = colorScheme == .dark ? Color.white.opacity(0.05) :  Color.black.opacity(0.05)

        HorStack(spacing: 6) {
            Circle()
                .fill(entry.level.color)
                .frame(width: 8, height: 8)
                .shadow(color: entry.level.color.opacity(0.8), radius: 4)

            Text(entry.category)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color, in: Capsule())
    }

    var level: some View {
        VerStack(spacing: 4) {
            Text(entry.level.image)
                .font(.system(size: 32))

            Text(entry.level.name)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(.primary)

            Text(Strings.widgetsLvl)
                .font(.system(size: 9, weight: .heavy))
                .foregroundStyle(.tertiary)
        }
    }

    var progress: some View {
        ProgressView(value: Float(entry.procentsToNextLevel) / 100)
            .tint(entry.level.color)
    }
}
