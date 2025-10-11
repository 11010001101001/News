//
//  InfoCell.swift
//  News
//
//  Created by Ярослав Куприянов on 02.04.2024.
//

import SwiftUI

struct InfoCell: View, ImageProvider {
	let id: String

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
	}
}
