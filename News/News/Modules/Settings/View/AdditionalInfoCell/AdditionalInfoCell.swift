//
//  AdditionalInfoCell.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

struct AdditionalInfoCell: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Group {
            InfoCell(id: DeveloperInfo.currentAppVersion)
            LinkCell(
                viewModel: viewModel,
                id: Texts.App.contactUs(),
                link: DeveloperInfo.contactLink
            )
        }
    }
}
