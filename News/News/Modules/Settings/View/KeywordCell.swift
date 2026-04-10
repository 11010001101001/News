//
//  HighlightKeywordCell.swift
//  News
//
//  Created by Ярослав Куприянов on 29.03.2024.
//

import SwiftUI

struct KeywordCell: View, ImageProvider {
	@ObservedObject var viewModel: SettingsViewModel
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
private extension KeywordCell {
    var title: some View {
        HorStack(spacing: Constants.padding) {
            getImage(for: NewsKeyword.title)
                .padding(.leading, Constants.padding)
            DesignedText(text: NewsKeyword.title)
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .leading)
            Spacer()
        }
    }

    var textField: some View {
        TextField(String.empty, text: $keyword, prompt: subtitle)
            .font(.system(size: 15, design: .monospaced))
            .foregroundStyle(.background)
            .lineLimit(1)
            .padding(.horizontal, Constants.padding * 2)
            .onSubmit {
                viewModel.applyKeyword(keyword)
            }
    }

    var subtitle: Text {
        Text(NewsKeyword.prompt)
            .font(.system(size: 14, design: .monospaced))
            .foregroundStyle(.background)
    }
}
