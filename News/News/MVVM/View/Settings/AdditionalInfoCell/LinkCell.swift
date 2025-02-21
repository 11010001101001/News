//
//  LinkCell.swift
//  News
//
//  Created by Ярослав Куприянов on 02.04.2024.
//

import SwiftUI

struct LinkCell: View, ImageProvider {
	@ObservedObject private var viewModel: ViewModel
	@Environment(\.openURL) private var openURL

	private let id: String
	private let link: URL

	init(
		viewModel: ViewModel,
		id: String,
		link: URL
	) {
		self.viewModel = viewModel
		self.id = id
		self.link = link
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
		.card()
		.frame(height: 70)
		.modifier(
			OnTap(
				execute: { viewModel.impactOccured(.light) },
				completion: { openURL(link) }
			)
		)
	}
}

#Preview {
	LinkCell(
		viewModel: ViewModel(),
		id: Texts.App.contactUs(),
		link: URL(string: "https://www.google.com")!
	)
}
