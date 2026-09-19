//
//  LanguageCell.swift
//  News
//
//  Created by Slava on 19.09.2026.
//

import SwiftUI

struct LanguageCell: View, ImageProvider {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        HorStack(spacing: Constants.padding) {
            getImage(for: Texts.Settings.language())
                .padding(.leading, Constants.padding)
            DesignedText(text: Texts.Settings.language())
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .leading)
            Spacer()
            Menu {
                ForEach(viewModel.availableLanguages) { language in
                    Button {
                        viewModel.applySettings(language.rawValue)
                    } label: {
                        if viewModel.checkIsEnabled(language.rawValue) {
                            Label("\(language.flag)  \(language.title)", systemImage: "checkmark")
                        } else {
                            Text("\(language.flag)  \(language.title)")
                        }
                    }
                }
            } label: {
                HorStack(spacing: 6) {
                    Text(viewModel.currentLanguageItem.flag)
                        .font(.subheadline)
                    DesignedText(text: viewModel.currentLanguageItem.title)
                        .font(.subheadline)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.trailing, Constants.padding)
            }
            .tint(.primary)
        }
        .glassCard()
        .frame(height: 70)
    }
}
