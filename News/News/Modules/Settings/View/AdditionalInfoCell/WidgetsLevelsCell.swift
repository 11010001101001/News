//
//  InfoCell.swift
//  News
//
//  Created by Ярослав Куприянов on 02.04.2024.
//

import SwiftUI

struct WidgetsLevelsCell: View, ImageProvider {
    let id: String

    var body: some View {
        HorStack(spacing: Constants.padding) {
            getImage(for: id)
                .padding(.leading, Constants.padding)
            group
            Spacer()
        }
        .glassRegularCard()
        .frame(height: 70)
    }
}

// MARK: - Private
private extension WidgetsLevelsCell {
    var title: some View {
        DesignedText(text: id.capitalizingFirstLetter())
            .font(.headline)
            .foregroundStyle(.foreground)
            .frame(maxHeight: .infinity, alignment: .leading)
    }

    var group: some View {
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

    var instruction: some View {
        DesignedText(text: Texts.Widgets.instuction())
            .font(.headline)
    }

    func buildDescription(level: Level) -> some View {
        VerStack(spacing: 8) {
            DesignedText(text: "Lvl: " + level.image + .spacer + level.rawValue)
                .font(.headline)
                .shadow(color: level.color, radius: 7)

            DesignedText(text: Texts.Widgets.range(level.range))
                .font(.subheadline)
        }
        .padding(.leading, 8)
    }
}
