//
//  ShareButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI

struct ShareButton: View {
	@State var imageWrapper: ContentWrapper?
	let data: ButtonMetaData
    let viewModel: DetailsViewModel

	var body: some View {
		CustomButton(
			action: {
                viewModel.impactOccured(.light)
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
