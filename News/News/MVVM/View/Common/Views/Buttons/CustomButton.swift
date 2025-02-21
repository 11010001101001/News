//
//  CustomButton.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

struct CustomButton: View {
	@ObservedObject private var viewModel: ViewModel

	private let action: Action
	private var title: String?
	private var iconName: String?

	init(
		viewModel: ViewModel,
		action: Action,
		title: String? = nil,
		iconName: String? = nil
	) {
		self.viewModel = viewModel
		self.action = action
		self.title = title
		self.iconName = iconName
	}

	var body: some View {
		ConditionalView(action != nil) {
			Button(
				action: {
					buttonAction?()
				},
				label: {
					Label(
						title: { titleView },
						icon: { iconView }
					)
				}
			)
			.buttonStyle(.bordered)
			.clipShape(.capsule(style: .continuous))
		}
	}

	private var buttonAction: Action {
		{
			viewModel.impactOccured(.light)
			action?()
		}
	}

	private var titleView: some View {
		Group {
			if title == nil {
				EmptyView()
			} else {
				DesignedText(text: title ?? .empty)
					.foregroundStyle(.white)
			}
		}
	}

	private var iconView: some View {
		iconName == nil ? nil : Image(systemName: iconName!).foregroundStyle(.white)
	}
}

#Preview {
	CustomButton(viewModel: ViewModel(),
				 action: {},
				 title: "Tap me",
				 iconName: "square.and.arrow.down.on.square")
}
