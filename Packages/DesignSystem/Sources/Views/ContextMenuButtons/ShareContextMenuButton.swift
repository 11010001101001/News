//
//  ShareContextMenuButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI
import CoreKit
import LocalizationKit

public struct ShareContextMenuButton: View {
    @Binding var imageWrapper: ContentWrapper?
    private let action: () -> Void
    private let urlString: String

    public init(imageWrapper: Binding<ContentWrapper?>, action: @escaping () -> Void, urlString: String) {
        self._imageWrapper = imageWrapper
        self.action = action
        self.urlString = urlString
    }

    public var body: some View {
        CustomButton(
            action: {
                action()

                imageWrapper = ContentWrapper(
                    link: (URL(string: urlString)?.absoluteString).orEmpty,
                    description: DeveloperInfo.shareInfo
                )
            },
            title: Strings.contextMenuShare,
            iconName: SFSymbols.squareAndArrowUp.rawValue,
            isGlass: false
        )
    }
}
