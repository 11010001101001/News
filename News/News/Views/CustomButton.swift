//
//  CustomButton.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

struct CustomButton: View {
	private let action: Action
	private var title: String?
	private var iconName: String?

	init(
		action: Action,
		title: String? = nil,
		iconName: String? = nil
	) {
		self.action = action
		self.title = title
		self.iconName = iconName
	}

	var body: some View {
		ConditionalView(action != nil) {
			Button(
				action: {
					action?()
				},
				label: {
					Label(
						title: { titleView },
						icon: { iconView }
					)
				}
			)
            .buttonStyle(.glass)
		}
	}

	private var titleView: some View {
        ConditionalView(title != nil) {
            DesignedText(text: title ?? .empty)
                .foregroundStyle(.white)
        }
	}

	private var iconView: some View {
        ConditionalView(iconName != nil) {
            Image(systemName: iconName!)
                .foregroundStyle(.white)
        }
	}
}
