//
//  SettingsList.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Lottie
import SwiftUI
import LocalizationKit
import ModelsKit
import DesignSystem

struct SettingsList: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        TabView {
            Tab(Strings.loaderTitle, systemImage: LoaderConfiguration.tabImage) {
                buildContentScroll {
                    ForEach(LoaderConfiguration.allCases) { loader in
                        LoaderSettingsCell(viewModel: viewModel, loader: loader)
                    }
                }
            }

            Tab(Strings.categoryTitle, systemImage: NewsCategory.tabImage) {
                buildContentScroll {
                    VerStack(spacing: Constants.padding) {
                        ForEach(NewsCategory.allCases) { category in
                            SettingsCell(viewModel: viewModel, model: category)
                        }
                        KeywordCell(viewModel: viewModel, keyword: viewModel.keyword)
                    }
                }
            }

            Tab(Strings.soundTitle, systemImage: SoundTheme.tabImage) {
                buildContentScroll {
                    ForEach(SoundTheme.allCases) { theme in
                        SettingsCell(viewModel: viewModel, model: theme)
                    }
                }
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
                DesignedText(text: Strings.screenSettingsTitle)
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
        ScrollView {
            VerStack(spacing: Constants.padding) {
                content()
            }
            .padding(.all, Constants.padding)
        }
    }
}
