//
//  AdditionalInfoCell.swift
//  News
//
//  Created by Ярослав Куприянов on 16.11.2024.
//

import Foundation
import SwiftUI
import LocalizationKit
import ModelsKit

struct AdditionalInfoCell: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        Group {
            WidgetLevelsCell(id: String(localized: Strings.widgetsLevels))
            LanguageCell(viewModel: viewModel)
            InfoCell(id: Strings.appVersion(DeveloperInfo.currentAppVersion))
            ContactUsCell(
                viewModel: viewModel,
                id: Strings.appContactUs,
                link: DeveloperInfo.contactLink
            )
        }
    }
}
