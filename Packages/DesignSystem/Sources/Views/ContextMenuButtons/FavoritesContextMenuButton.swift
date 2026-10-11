//
//  FavoritesContextMenuButton.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI
import LocalizationKit

public struct FavoritesContextMenuButton: View {
    private let action: () -> Void
    private let title: LocalizedStringResource
    private let iconName: String

    public init(action: @escaping () -> Void, title: LocalizedStringResource, iconName: String) {
        self.action = action
        self.title = title
        self.iconName = iconName
    }

    public var body: some View {
        CustomButton(
            action: action,
            title: title,
            iconName: iconName,
            isGlass: false
        )
    }
}
