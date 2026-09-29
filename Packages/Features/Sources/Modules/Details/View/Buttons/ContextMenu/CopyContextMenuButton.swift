//
//  CopyContextMenuButton.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI
import DesignSystem
import LocalizationKit

struct CopyContextMenuButton: View {
    let viewModel: DetailsViewModel

    var body: some View {
        CustomButton(
            action: { viewModel.copyDescription() },
            title: Strings.contextMenuCopy,
            iconName: SFSymbols.documentOnDocument.rawValue,
            isGlass: false
        )
    }
}
