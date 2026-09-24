//
//  ShareButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI
import DesignSystem
import ModelsKit
import CoreKit
import LocalizationKit

struct MarkAsReadContextMenuButton: View {
    let viewModel: DetailsViewModel
    let article: Article

    private var isRead: Bool {
        viewModel.checkIsRead(article.key)
    }

    private var iconName: String {
        isRead ? SFSymbols.checkmarkSealFill.rawValue : SFSymbols.checkmarkSeal.rawValue
    }

    private var title: LocalizedStringResource {
        isRead ? Strings.contextMenuMarkAsUnread : Strings.contextMenuMarkAsRead
    }

    var body: some View {
        CustomButton(
            action: {
                viewModel.impactOccured(.light)
                if isRead {
                    viewModel.markAsUnread(article)
                } else {
                    viewModel.markAsRead(article)
                }
            },
            title: title,
            iconName: iconName,
            isGlass: false
        )
    }
}
