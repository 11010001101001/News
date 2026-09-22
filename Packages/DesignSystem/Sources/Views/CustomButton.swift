//
//  CustomButton.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

public struct CustomButton: View {
    public let action: () -> Void
    var title: LocalizedStringResource?
    var iconName: String?
    var isGlass = true
    
    public init(
        action: @escaping () -> Void,
        title: LocalizedStringResource? = nil,
        iconName: String? = nil,
        isGlass: Bool = true
    ) {
        self.action = action
        self.title = title
        self.iconName = iconName
        self.isGlass = isGlass
    }

    public var body: some View {
        let button = Button(
            action: {
                action()
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
extension CustomButton {
    fileprivate var label: some View {
        Label(
            title: { titleView },
            icon: { iconView }
        )
    }

    fileprivate var titleView: some View {
        OptionalView(title) {
            DesignedText(text: $0)
                .foregroundStyle(.white)
        }
    }

    fileprivate var iconView: some View {
        OptionalView(iconName) {
            Image(systemName: $0)
                .foregroundStyle(.white)
        }
    }
}
