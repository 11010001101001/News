//
//  SettingsList.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import Lottie

struct SettingsList: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        TabView {
            Tab(Texts.Loader.title(), systemImage: LoaderConfiguration.image) {
                buildContentScroll {
                    ForEach(LoaderConfiguration.allCases) { loader in
                        LoaderSettingsCell(viewModel: viewModel, id: loader.rawValue)
                    }
                }
            }

            Tab(Texts.Category.title(), systemImage: NewsCategory.image) {
                buildContentScroll {
                    VerStack(spacing: Constants.padding) {
                        ForEach(NewsCategory.allCases) { category in
                            SettingsCell(viewModel: viewModel, id: category.rawValue)
                        }
                        KeywordCell(viewModel: viewModel, keyword: viewModel.keyword)
                    }
                }
            }

            Tab(Texts.Sound.title(), systemImage: SoundTheme.image) {
                buildContentScroll {
                    ForEach(SoundTheme.allCases) { theme in
                        SettingsCell(viewModel: viewModel, id: theme.rawValue)
                    }
                }
            }

            if UIApplication.shared.supportsAlternateIcons {
                Tab(Texts.AppIcon.title(), systemImage: AppIconConfiguration.image) {
                    buildContentScroll {
                        ForEach(AppIconConfiguration.allCases) { theme in
                            AppIconSettingsCell(viewModel: viewModel, id: theme.rawValue)
                        }
                    }
                }
            }

            Tab(AdditionalInfo.title, systemImage: AdditionalInfo.image) {
                buildContentScroll {
                    AdditionalInfoCell(viewModel: viewModel)
                }
            }
        }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .principal) {
                DesignedText(text: Texts.Screen.Settings.title())
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
