//
//  SettingsList.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import Lottie

struct SettingsList: View {
    @ObservedObject private var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TabView {
            Tab(LoaderConfiguration.title, systemImage: LoaderConfiguration.image) {
                buildContentScroll(title: LoaderConfiguration.title) {
                    ForEach(LoaderConfiguration.allCases) { loader in
                        LoaderSettingsCell(viewModel: viewModel, id: loader.rawValue)
                    }
                }
            }

            Tab(Category.title, systemImage: Category.image) {
                buildContentScroll(title: Category.title) {
                    ForEach(Category.allCases) { category in
                        SettingsCell(viewModel: viewModel, id: category.rawValue)
                    }
                }
            }

            Tab(SoundTheme.title, systemImage: SoundTheme.image) {
                buildContentScroll(title: SoundTheme.title) {
                    ForEach(SoundTheme.allCases) { theme in
                        SettingsCell(viewModel: viewModel, id: theme.rawValue)
                    }
                }
            }

            if UIApplication.shared.supportsAlternateIcons {
                Tab(AppIconConfiguration.title, systemImage: AppIconConfiguration.image) {
                    buildContentScroll(title: AppIconConfiguration.title) {
                        ForEach(AppIconConfiguration.allCases) { theme in
                            AppIconSettingsCell(viewModel: viewModel, id: theme.rawValue)
                        }
                    }
                }
            }

            Tab(AdditionalInfo.title, systemImage: AdditionalInfo.image) {
                buildContentScroll(title: AdditionalInfo.title) {
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
    func buildContentScroll(
        title: String,
        content: @escaping () -> some View
    ) -> some View {
        ScrollView {
            VerStack(spacing: Constants.padding) {
                content()
            }
            .padding(.all, Constants.padding)
        }
    }
}
