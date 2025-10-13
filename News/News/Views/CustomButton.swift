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
    var isGlass = true

    var body: some View {
        let button = Button(
            action: {
                action?()
            },
            label: {
                label
            }
        )

        ConditionalView(isGlass) {
            OptionalView(action) { action in
                button
                    .buttonStyle(.glass)
            }
        }
        ConditionalView(!isGlass) {
            button
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
