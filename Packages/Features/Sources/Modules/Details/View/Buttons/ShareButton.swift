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

struct ShareButton: View {
    @State var imageWrapper: ContentWrapper?
    let viewModel: DetailsViewModel
    let isGlass: Bool

    var body: some View {
        CustomButton(
            action: {
                viewModel.impactOccured(.light)

                self.imageWrapper = ContentWrapper(
                    link: (URL(string: viewModel.url)?.absoluteString).orEmpty,
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
