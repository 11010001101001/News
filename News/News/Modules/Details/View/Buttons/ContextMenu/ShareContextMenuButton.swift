//
//  ShareButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI

struct ShareContextMenuButton: View {
    @Binding var imageWrapper: ContentWrapper?

	let data: ButtonMetaData
    let viewModel: DetailsViewModel
    let isGlass: Bool

	var body: some View {
		CustomButton(
			action: {
                viewModel.impactOccured(.light)
                
                imageWrapper = ContentWrapper(
                    link: (URL(string: data.article.url.orEmpty)?.absoluteString).orEmpty,
                    description: DeveloperInfo.shareInfo
                )
			},
			title: data.title,
            iconName: data.iconName,
            isGlass: isGlass
		)
	}
}
