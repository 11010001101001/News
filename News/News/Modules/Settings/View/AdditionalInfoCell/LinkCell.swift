//
//  LinkCell.swift
//  News
//
//  Created by Ярослав Куприянов on 02.04.2024.
//

import SwiftUI

struct LinkCell: View, ImageProvider {
	@ObservedObject var viewModel: SettingsViewModel
	let id: String
	let link: URL
    
    @Environment(\.openURL) private var openURL

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
		.frame(height: 70)
		.modifier(
			OnTap(
				execute: { viewModel.impactOccured(.light) },
				completion: { openURL(link) }
			)
		)
	}
}
