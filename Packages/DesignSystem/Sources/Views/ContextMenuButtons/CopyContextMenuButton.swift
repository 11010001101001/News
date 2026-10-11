//
//  CopyContextMenuButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI
import LocalizationKit

public struct CopyContextMenuButton: View {
    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        CustomButton(
            action: action,
            title: Strings.contextMenuCopy,
            iconName: SFSymbols.documentOnDocument.rawValue,
            isGlass: false
        )
    }
}
