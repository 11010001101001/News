//
//  CustomButton.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

struct CustomButton: View {
	let action: Action
	var title: String?
	var iconName: String?

	var body: some View {
		ConditionalView(action != nil) {
			Button(
				action: {
                    action?()
				},
				label: {
                    label
				}
			)
            .buttonStyle(.glass)
		}
	}
}

// MARK: - Contents
private extension CustomButton {
    var label: some View {
        Label(
            title: { titleView },
            icon: { iconView }
        )
    }

    var titleView: some View {
        ConditionalView(title != nil) {
            DesignedText(text: title ?? .empty)
                .foregroundStyle(.white)
        }
    }

    var iconView: some View {
        ConditionalView(iconName != nil) {
            Image(systemName: iconName!)
                .foregroundStyle(.white)
        }
    }
}
