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

    @State private var isRulesExpanded = false

    var body: some View {
        VerStack {
            LevelView(entry: entry)
            progressLine
            rules
        }
        .glassClearInteractive()
    }

    var progressLine: some View {
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

    var rules: some View {
        HorStack {
            VerStack(spacing: 16) {
                Button(
                    action: {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0.15)) {
                            isRulesExpanded.toggle()
                        }
                    },
                    label: {
                        HorStack(spacing: 4) {
                            DesignedText(Strings.infoRules)
                                .font(.caption)
                            Image(systemName: SFSymbols.chevronDown.rawValue)
                                .rotationEffect(.degrees(isRulesExpanded ? 180 : 0))
                        }
                        .tint(.secondary)
                    })

                ConditionalView(isRulesExpanded) {
                    DesignedText(Strings.widgetsInstuction)
                        .font(.callout)
                    buildDescription(level: .techNinja)
                    buildDescription(level: .insider)
                    buildDescription(level: .observer)
                    buildDescription(level: .newbie)
                }
            }
            Spacer()
        }
        .padding(Constants.padding)
        .background(
            .black.opacity(0.25), in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    fileprivate func buildDescription(level: Level) -> some View {
        VerStack(spacing: 8) {
            HorStack {
                DesignedText(.init(stringLiteral: level.image + .spacer))
                DesignedText(level.name)
            }
            .font(.callout)
            .shadow(color: entry.level == level ? level.color : .clear, radius: 7)

            DesignedText(Strings.widgetsRange(level.range))
                .font(.callout)
        }
    }
}
