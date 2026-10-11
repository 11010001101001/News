//
//  RulesView.swift
//  Features
//
//  Created by Slava on 12.10.2026.
//

import DesignSystem
import LocalizationKit
import ModelsKit
import SwiftUI

struct RulesView: View {
    let entry: Entry

    @State private var isRulesExpanded = false

    var body: some View {
        HorStack {
            VerStack(spacing: 16) {
                rulesButton

                ConditionalView(isRulesExpanded) {
                    descriptions
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
}

// MARK: Private
extension RulesView {
    fileprivate var rulesButton: some View {
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
    }

    @ViewBuilder
    fileprivate var descriptions: some View {
        DesignedText(Strings.widgetsInstuction)
            .font(.callout)
        buildDescription(level: .techNinja)
        buildDescription(level: .insider)
        buildDescription(level: .observer)
        buildDescription(level: .newbie)
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
