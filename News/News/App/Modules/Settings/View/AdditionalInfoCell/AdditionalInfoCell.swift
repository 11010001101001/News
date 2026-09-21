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
            WidgetLevelsCell(id: String(localized: .widgetsLevels))
            LanguageCell(viewModel: viewModel)
            InfoCell(id: .appVersion(DeveloperInfo.currentAppVersion))
            ContactUsCell(
                viewModel: viewModel,
                id: .appContactUs,
                link: DeveloperInfo.contactLink
            )
        }
    }
}
