//
//  KeywordSection.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import DesignSystem
import LocalizationKit

struct KeywordSection: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        VerStack(spacing: 10) {
            Label(Strings.keywordTitle, systemImage: "sparkles")
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            HorStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.tertiary)

                TextField(Strings.keywordPlaceHolder, text: $viewModel.keyword)
                    .textFieldStyle(.plain)
                    .font(.body.weight(.medium))
                    .onSubmit {
                        viewModel.notificationOccurred(.success)
                    }

                if !viewModel.keyword.isEmpty {
                    Button(action: {
                        viewModel.keyword = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    })
                }
            }
            .padding()
            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(viewModel.keyword.isEmpty ? .clear : .blue.opacity(0.5), lineWidth: 1)
            )
        }
    }
}
