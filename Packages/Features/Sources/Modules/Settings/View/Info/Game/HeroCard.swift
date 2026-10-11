//
//  HeroCard.swift
//  News
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import DesignSystem
import Foundation
import LocalizationKit
import ModelsKit
import SwiftUI

struct HeroCard: View {
    let entry: Entry

    var body: some View {
        VerStack {
            LevelView(entry: entry)
            progressLine
            RulesView(entry: entry)
        }
        .glassClearInteractive()
    }

    fileprivate var progressLine: some View {
        VerStack(spacing: 8) {
            HorStack {
                Text(entry.isMaxLevel ? Strings.widgetsMaxLevel : Strings.widgetsProgress)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(entry.procentsToNextLevel)" + "%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.level.color)
            }

            ProgressView(value: Float(entry.procentsToNextLevel) / 100)
                .tint(entry.level.color)
                .shadow(
                    color: entry.isMaxLevel ? entry.level.color.opacity(0.8) : .clear, radius: 4)
        }
        .padding(Constants.padding)
        .background(
            .black.opacity(0.25), in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .padding(.horizontal, Constants.padding)
    }
}
