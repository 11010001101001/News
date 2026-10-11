//
//  File.swift
//  Features
//
//  Created by Slava on 12.10.2026.
//

import SwiftUI
import CoreKit
import LocalizationKit
import DesignSystem
import ModelsKit

struct LevelCard: View {
    let entry: Entry

    var body: some View {
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
}
