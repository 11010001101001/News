//
//  HighlightKeywordCell.swift
//  News
//
//  Created by Ярослав Куприянов on 29.03.2024.
//

import SwiftUI
import DesignSystem
import LocalizationKit

struct KeywordCell: View {
    @Bindable var viewModel: SettingsViewModel
    @State var keyword: String

    var body: some View {
        VerStack(spacing: Constants.padding) {
            title
            textField
        }
        .padding(.vertical, Constants.padding)
        .glassCard()
    }
}

// MARK: - Private
extension KeywordCell {
    fileprivate var title: some View {
        HorStack(spacing: Constants.padding) {
            Image(systemName: SFSymbols.lightMax.rawValue)
                .padding(.leading, Constants.padding)
            DesignedText(Strings.keywordTitle)
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .leading)
            Spacer()
        }
    }

    fileprivate var textField: some View {
        TextField(String.empty, text: $keyword, prompt: subtitle)
            .font(.system(size: 15, design: .monospaced))
            .foregroundStyle(.background)
            .lineLimit(1)
            .padding(.horizontal, Constants.padding * 2)
            .onSubmit {
                viewModel.applyKeyword(keyword)
            }
    }

    fileprivate var subtitle: Text {
        Text(Strings.keywordPromt)
            .font(.system(size: 14, design: .monospaced))
            .foregroundStyle(.background)
    }
}
