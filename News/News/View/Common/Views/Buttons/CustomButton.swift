//
//  CustomButton.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

struct CustomButton: View {
	@ObservedObject private var viewModel: ViewModel
	@State private var scale: CGFloat = 1.0

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
			.scaleEffect(scale)
		}
	}

	private var buttonAction: Action {
		{
			viewModel.impactOccured(.light)
			withAnimation(.easeInOut(duration: .zero)) {
				scale = 0.90
			} completion: {
				withAnimation(.easeInOut(duration: 0.15)) {
					scale = 1.0
				} completion: {
					action?()
				}
			}
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
