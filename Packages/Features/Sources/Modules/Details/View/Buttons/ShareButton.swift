//
//  ShareButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI
import ModelsKit
import DesignSystem
import CoreKit
import LocalizationKit

struct ShareButton: View {
    @State var imageWrapper: ContentWrapper?
    let action: () -> Void
    let urlString: String
    let isGlass: Bool

    var body: some View {
        CustomButton(
            action: {
                action()

                self.imageWrapper = ContentWrapper(
                    link: (URL(string: urlString)?.absoluteString).orEmpty,
                    description: DeveloperInfo.shareInfo
                )
            },
            title: nil,
            iconName: SFSymbols.squareAndArrowUp.rawValue,
            isGlass: isGlass
        )
        .sheet(
            item: $imageWrapper,
            content: { content in
                ActivityViewController(contentWrapper: content)
                    .presentationDetents([.medium])
            }
        )
    }
}
