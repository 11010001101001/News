//
//  AdditionalInfoCell.swift
//  News
//
//  Created by Ярослав Куприянов on 16.11.2024.
//

import Foundation
import SwiftUI

struct AdditionalInfoCell: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        Group {
            WidgetLevelsCell(id: Texts.Widgets.levels())
            LanguageCell(viewModel: viewModel)
            InfoCell(id: DeveloperInfo.currentAppVersion)
            LinkCell(
                viewModel: viewModel,
                id: Texts.App.contactUs(),
                link: DeveloperInfo.contactLink
            )
        }
    }
}
