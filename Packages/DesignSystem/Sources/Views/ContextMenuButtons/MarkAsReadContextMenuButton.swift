//
//  MarkAsReadContextMenuButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI
import CoreKit
import LocalizationKit

public struct MarkAsReadContextMenuButton: View {
    private let action: () -> Void
    private let title: LocalizedStringResource
    private let iconName: String

    public init(
        action: @escaping () -> Void,
        title: LocalizedStringResource,
        iconName: String
    ) {
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
