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
        OptionalView(action) { action in
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

// MARK: - Content
private extension CustomButton {
    var label: some View {
        Label(
            title: { titleView },
            icon: { iconView }
        )
    }

    var titleView: some View {
        OptionalView(title) {
            DesignedText(text: $0)
                .foregroundStyle(.white)
        }
    }

    var iconView: some View {
        OptionalView(iconName) {
            Image(systemName: $0)
                .foregroundStyle(.white)
        }
    }
}
