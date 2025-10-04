//
//  ShareButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI

struct ShareButton: View {
	@State private var imageWrapper: ContentWrapper?
	private let data: ButtonMetaData

	init(
		imageWrapper: ContentWrapper? = nil,
		data: ButtonMetaData
	) {
		self.imageWrapper = imageWrapper
		self.data = data
	}

	var body: some View {
		CustomButton(
			action: {
				self.imageWrapper = ContentWrapper(
					link: URL(string: data.article.url ?? .empty)?.absoluteString ?? .empty,
					description: DeveloperInfo.shareInfo)
			},
			title: data.title,
			iconName: data.iconName
		)

		.sheet(
			item: $imageWrapper,
			content: { content in
				ActivityViewController(contentWrapper: content)
					.presentationDetents([.medium])
			}
		)
	}
}
