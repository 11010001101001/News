//
//  SettingsCell.swift
//  News
//
//  Created by Ярослав Куприянов on 29.03.2024.
//

import SwiftUI
import CoreKit
import DesignSystem

struct SettingsCell<T: DisplayName>: View {
    @Bindable var viewModel: SettingsViewModel
    let model: T

    private var id: String {
        model.rawValue
    }

    var body: some View {
        HorStack(spacing: Constants.padding) {
            ImageProvider.image(id)
                .padding(.leading, Constants.padding)

            DesignedText(text: model.displayName)
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .leading)

            Spacer()
        }
        .glassCard()
        .markIsSelected(viewModel, id)
        .frame(height: 70)
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.checkIsEnabled(id.lowercased())
        ) {
            viewModel.applySettings(id.lowercased())
        }
    }
}
