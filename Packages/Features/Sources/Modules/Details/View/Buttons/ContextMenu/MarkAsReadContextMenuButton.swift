//
//  MarkAsReadContextMenuButton.swift
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

    var body: some View {
        CustomButton(
            action: { viewModel.markAsReadOrUnread() },
            title: viewModel.isReadTitle,
            iconName: viewModel.isReadIcon,
            isGlass: false
        )
    }
}
