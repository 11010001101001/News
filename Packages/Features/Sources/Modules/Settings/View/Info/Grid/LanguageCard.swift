//
//  LanguageCard.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import DesignSystem
import ModelsKit
import LocalizationKit

struct LanguageCard: View {
    let viewModel: SettingsViewModel

    var body: some View {
        VerStack(alignment: .center, spacing: Constants.padding) {
            Image(systemName: SFSymbols.globe.rawValue)
                .font(.title2)

            menu
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .glassClearInteractive()
    }
}

extension LanguageCard {
    fileprivate var menu: some View {
        Menu {
            ForEach(AppLanguage.allCases) { language in
                Button {
                    viewModel.language = language
                } label: {
                    if viewModel.language == language {
                        Label(
                            "\(language.flag)  \(language.title)",
                            systemImage: "checkmark"
                        )
                    } else {
                        Text("\(language.flag)  \(language.title)")
                    }
                }
            }
        } label: {
            HorStack(spacing: 6) {
                Text(viewModel.language.flag)
                    .font(.callout)
                Text(viewModel.language.title)
                    .font(.callout)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, Constants.padding)
            .lineLimit(1)
        }
        .tint(.primary)
    }
}
