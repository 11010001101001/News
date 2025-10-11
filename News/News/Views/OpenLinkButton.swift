//
//  OpenLinkButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import SwiftUI

struct OpenLinkButton: View {
	let data: ButtonMetaData

    @Environment(\.openURL) private var openURL

	var body: some View {
		CustomButton(
			action: { Task { openLinkAction?() } },
			title: data.title,
			iconName: data.iconName
		)
	}

	private var openLinkAction: Action {
		{
			if let url = URL(string: data.article.url ?? .empty) {
				openURL(url)
			}
		}
	}
}
