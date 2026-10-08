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

    var body: some View {
        HorStack(spacing: Constants.padding) {
            ImageProvider
                .image(model.rawValue)
                .padding(.leading, Constants.padding)

            DesignedText(model.displayName)
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .leading)

            Spacer()
        }
        .markIsSelected(viewModel.category == model.rawValue)
        .glassClearInteractive()
        .frame(height: 70)
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.category == model.rawValue
        ) {
            viewModel.applySettings(model.rawValue)
        }
    }
}
