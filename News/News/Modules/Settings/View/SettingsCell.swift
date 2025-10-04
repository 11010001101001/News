//
//  SettingsCell.swift
//  News
//
//  Created by Ярослав Куприянов on 29.03.2024.
//

import SwiftUI

struct SettingsCell: View, ImageProvider {
	@ObservedObject private var viewModel: SettingsViewModel
	private let id: String

	init(viewModel: SettingsViewModel, id: String) {
		self.viewModel = viewModel
		self.id = id
	}

	var body: some View {
		HorStack(spacing: Constants.padding) {
			getImage(for: id)
				.padding(.leading, Constants.padding)
			DesignedText(text: id.capitalizingFirstLetter())
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
