//
//  SettingsList.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import Lottie

struct SettingsList: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView {
            Tab(LoaderConfiguration.title, systemImage: LoaderConfiguration.image) {
                buildContentScroll {
                    ForEach(LoaderConfiguration.allCases) { loader in
                        LoaderSettingsCell(viewModel: viewModel, id: loader.rawValue)
                    }
                }
            }

            Tab(NewsCategory.title, systemImage: NewsCategory.image) {
                buildContentScroll {
                    ForEach(NewsCategory.allCases) { category in
                        SettingsCell(viewModel: viewModel, id: category.rawValue)
                    }
                }
            }

            Tab(SoundTheme.title, systemImage: SoundTheme.image) {
                buildContentScroll {
                    ForEach(SoundTheme.allCases) { theme in
                        SettingsCell(viewModel: viewModel, id: theme.rawValue)
                    }
                }
            }

            if UIApplication.shared.supportsAlternateIcons {
                Tab(AppIconConfiguration.title, systemImage: AppIconConfiguration.image) {
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
            ToolbarItem(placement: .topBarLeading) {
                NavButton(
                    type: .back,
                    action: { dismiss() }
                )
            }

            ToolbarItem(placement: .principal) {
                DesignedText(text: Texts.Screen.Settings.title())
                    .font(.title)
            }
        }
        .scrollIndicators(.automatic)
        .navigationBarBackButtonHidden(true)
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
