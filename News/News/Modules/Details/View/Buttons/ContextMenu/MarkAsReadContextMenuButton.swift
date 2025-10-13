//
//  ShareButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI

struct MarkAsReadContextMenuButton: View {
    let viewModel: DetailsViewModel
    let article: Article

    private var isRead: Bool {
        viewModel.checkIsRead(article.key)
    }

    private var iconName: String {
        isRead ? SFSymbols.checkmarkSealFill.rawValue : SFSymbols.checkmarkSeal.rawValue
    }

    private var title: String {
        isRead ? Texts.ContextMenu.markAsUnread() : Texts.ContextMenu.markAsRead()
    }

	var body: some View {
		CustomButton(
			action: {
                let key = article.key
                viewModel.impactOccured(.light)
                isRead ? viewModel.markAsUnread(key) : viewModel.markAsRead(key)
			},
			title: title,
            iconName: iconName,
            isGlass: false
		)
	}
}
