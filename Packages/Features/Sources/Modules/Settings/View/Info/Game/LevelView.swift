//
//  LevelView.swift
//  News
//
//  Created by Ярослав Куприянов on 29.20.2025.
//

import DesignSystem
import Foundation
import LocalizationKit
import SwiftUI
import ModelsKit

struct LevelView: View {
    let entry: Entry

    var body: some View {
        HorStack(spacing: 8) {
            levelCard
            categoryCard
        }
        .frame(minWidth: 120, maxHeight: .infinity, alignment: .leading)
        .padding(Constants.padding)
    }

    var levelCard: some View {
        VerStack(spacing: 8) {
            if entry.isMaxLevel {
                maxLevel
            } else {
                regularLevel
                Text(Strings.widgetsLvl)
                    .font(.caption2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.secondary)
                Spacer()
                Label(entry.date.time, systemImage: "clock.arrow.circlepath")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.black.opacity(0.25), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    var maxLevel: some View {
        HorStack {
            Spacer()
            VerStack(spacing: 4) {
                Text(entry.level.image)
                    .font(.system(size: 45))
                    .shadow(color: entry.level.color.opacity(0.8), radius: 4)

                Text(entry.level.name)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
    }

    var regularLevel: some View {
        HorStack(spacing: 6) {
            Text(entry.level.image)
                .font(.title2)
            Text(entry.level.name)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(.primary)
        }
    }

    var categoryCard: some View {
        VerStack(spacing: 6) {
            Circle()
                .fill(entry.level.color)
                .frame(width: 12, height: 12)
                .shadow(color: entry.level.color.opacity(0.8), radius: 6, x: 0, y: 0)

            Spacer()

            Text(Strings.widgetsCategory)
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text(entry.category)
                .font(.system(.callout, design: .rounded))
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .padding()
        .frame(minWidth: 120, maxHeight: .infinity, alignment: .leading)
        .background(.black.opacity(0.25), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
