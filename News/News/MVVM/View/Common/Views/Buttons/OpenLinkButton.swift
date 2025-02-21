//
//  OpenLinkButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import SwiftUI

struct OpenLinkButton: View {
	@Environment(\.openURL) private var openURL
	@ObservedObject private var viewModel: ViewModel
	private let data: ButtonMetaData

	init(
		viewModel: ViewModel,
		data: ButtonMetaData
	) {
		self.viewModel = viewModel
		self.data = data
	}

	var body: some View {
		CustomButton(
			viewModel: viewModel,
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
