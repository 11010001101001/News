//
//  LanguageCell.swift
//  News
//
//  Created by Slava on 19.09.2026.
//

import SwiftUI
import DesignSystem
import LocalizationKit

struct LanguageCell: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        HorStack(spacing: Constants.padding) {
            Image(systemName: SFSymbols.globe.rawValue)
                .padding(.leading, Constants.padding)
            DesignedText(Strings.settingsLanguage)
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .leading)
            Spacer()
            menu

        }
        .glassCard()
        .frame(height: 70)
    }
}

// MARK: - Private
extension LanguageCell {
    fileprivate var menu: some View {
        Menu {
            ForEach(viewModel.availableLanguages) { language in
                Button {
                    viewModel.applySettings(language.rawValue)
                } label: {
                    if viewModel.checkIsEnabled(language.rawValue) {
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
                Text(viewModel.currentLanguageItem.flag)
                    .font(.subheadline)
                Text(viewModel.currentLanguageItem.title)
                    .font(.subheadline)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.trailing, Constants.padding)
        }
        .tint(.primary)
    }
}
