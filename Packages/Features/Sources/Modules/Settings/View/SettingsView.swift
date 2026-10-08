//
//  SettingsView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import DesignSystem
import Foundation
import LocalizationKit
import ModelsKit
import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel

    var body: some View {
        TabView {
            Tab(Strings.loaderTitle, systemImage: LoaderConfiguration.tabImage) {
                LoadersCarusel(viewModel: viewModel)
            }

            Tab(Strings.categoryTitle, systemImage: NewsCategory.tabImage) {
                CategoryGrid(viewModel: viewModel)
            }

            Tab(Strings.soundTitle, systemImage: SoundTheme.tabImage) {
                SoundsGrid(viewModel: viewModel)
            }

            if UIApplication.shared.supportsAlternateIcons {
                Tab(Strings.appIconTitle, systemImage: AppIconConfiguration.tabImage) {
                    AppIconGrid(viewModel: viewModel)
                }
            }

            Tab(AdditionalInfo.title, systemImage: AdditionalInfo.tabImage) {
                InfoView(viewModel: viewModel)
            }
        }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .principal) {
                DesignedText(Strings.screenSettingsTitle)
                    .font(.title)
            }
        }
        .scrollIndicators(.automatic)
        .navigationBarTitleDisplayMode(.inline)
    }
}
