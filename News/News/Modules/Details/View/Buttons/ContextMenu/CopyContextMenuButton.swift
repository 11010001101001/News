//
//  ShareButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI

struct CopyContextMenuButton: View {
    let text: String

	var body: some View {
		CustomButton(
			action: {
                UIPasteboard.general.string = text
			},
			title: Texts.ContextMenu.copy(),
            iconName: SFSymbols.documentOnDocument.rawValue,
            isGlass: false
		)
	}
}
