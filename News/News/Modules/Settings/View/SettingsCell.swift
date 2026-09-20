//
//  SettingsCell.swift
//  News
//
//  Created by Ярослав Куприянов on 29.03.2024.
//

import SwiftUI

struct SettingsCell: View {
    @Bindable var viewModel: SettingsViewModel
    let id: String

    var body: some View {
        HorStack(spacing: Constants.padding) {
            ImageProvider.image(id)
                .padding(.leading, Constants.padding)
                         
            DesignedText(text: viewModel.displayName(for: id))
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

