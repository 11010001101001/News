//
//  InfoCell.swift
//  News
//
//  Created by Ярослав Куприянов on 02.04.2024.
//

import SwiftUI

struct InfoCell: View, ImageProvider {
	private let id: String

	init(id: String) {
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
		.card()
		.frame(height: 70)
	}
}

#Preview {
	InfoCell(id: DeveloperInfo.currentAppVersion)
}
