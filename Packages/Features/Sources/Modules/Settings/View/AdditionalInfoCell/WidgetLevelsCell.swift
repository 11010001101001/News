//
//  WidgetLevelsCell.swift
//  News
//
//  Created by Ярослав Куприянов on 02.04.2024.
//

import DesignSystem
import LocalizationKit
import ModelsKit
import SwiftUI

struct WidgetLevelsCell: View {
    let id: String

    var body: some View {
        HorStack(spacing: Constants.padding) {
            Image(systemName: SFSymbols.gamecontrollerFill.rawValue)
                .padding(.leading, Constants.padding)
            group
            Spacer()
        }
        .glassRegularCard()
        .frame(minHeight: 70)
    }
}

// MARK: - Private
extension WidgetLevelsCell {
    fileprivate var title: some View {
        DesignedText(Strings.widgetsLevels)
            .font(.headline)
            .foregroundStyle(.foreground)
            .frame(maxHeight: .infinity, alignment: .leading)
    }

    fileprivate var group: some View {
        DisclosureGroup {
            VerStack(spacing: 16) {
                instruction
                    .padding(.top, 16)
                buildDescription(level: .techNinja)
                buildDescription(level: .loopMaster)
                buildDescription(level: .curiousObserver)
                buildDescription(level: .newbie)
                    .padding(.bottom, 16)
            }
        } label: {
            title
        }
    }

    fileprivate var instruction: some View {
        DesignedText(Strings.widgetsInstuction)
            .font(.headline)
    }

    fileprivate func buildDescription(level: Level) -> some View {
        VerStack(spacing: 8) {
            HorStack {
                DesignedText(.init(stringLiteral: level.image + .spacer))
                DesignedText(level.name)
            }
            .font(.headline)
            .shadow(color: level.color, radius: 7)

            DesignedText(Strings.widgetsRange(level.range))
                .font(.subheadline)
        }
        .padding(.leading, 8)
    }
}
