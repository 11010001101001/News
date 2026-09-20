//
//  SettingsList.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Lottie
import SwiftUI

struct SettingsList: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        TabView {
            Tab(.loaderTitle, systemImage: LoaderConfiguration.tabImage) {
                buildContentScroll {
                    ForEach(LoaderConfiguration.allCases) { loader in
                        LoaderSettingsCell(viewModel: viewModel, id: loader.rawValue)
                    }
                }
            }

            Tab(.categoryTitle, systemImage: NewsCategory.tabImage) {
                buildContentScroll {
                    VerStack(spacing: Constants.padding) {
                        ForEach(NewsCategory.allCases) { category in
                            SettingsCell(viewModel: viewModel, id: category.rawValue)
                        }
                        KeywordCell(viewModel: viewModel, keyword: viewModel.keyword)
                    }
                }
            }

            Tab(.soundTitle, systemImage: SoundTheme.tabImage) {
                buildContentScroll {
                    ForEach(SoundTheme.allCases) { theme in
                        SettingsCell(viewModel: viewModel, id: theme.rawValue)
                    }
                }
            }

            if UIApplication.shared.supportsAlternateIcons {
                Tab(.appIconTitle, systemImage: AppIconConfiguration.tabImage) {
                    buildContentScroll {
                        ForEach(AppIconConfiguration.allCases) { theme in
                            AppIconSettingsCell(viewModel: viewModel, id: theme.rawValue)
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
                DesignedText(text: .screenSettingsTitle)
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
