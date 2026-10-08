//
//  SettingsList.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import DesignSystem
import LocalizationKit
import ModelsKit
import SwiftUI

struct SettingsList: View {
    @Bindable var viewModel: SettingsViewModel

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
                    buildContentScroll {
                        ForEach(AppIconConfiguration.allCases) { theme in
                            AppIconSettingsCell(viewModel: viewModel, theme: theme)
                        }
                    }
                }
            }

            Tab(AdditionalInfo.title, systemImage: AdditionalInfo.tabImage) {
                buildContentScroll {
                    AdditionalInfoCell(viewModel: viewModel)
                }
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

// MARK: - Private
extension SettingsList {
    func buildContentScroll(content: @escaping () -> some View) -> some View {
        GradientScrollView {
            VerStack(spacing: Constants.padding) {
                content()
            }
            .padding(.all, Constants.padding)
        }
    }
}
