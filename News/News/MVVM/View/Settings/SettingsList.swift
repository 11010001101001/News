//
//  SettingsList.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import Lottie

struct SettingsList: View {
	@ObservedObject private var viewModel: ViewModel
	@Environment(\.dismiss) var dismiss

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		TabView {
			buildTabItem(title: LoaderConfiguration.title) {
				ForEach(LoaderConfiguration.allCases) { loader in
					LoaderSettingsCell(viewModel: viewModel, id: loader.rawValue)
				}
			}

			buildTabItem(title: Category.title) {
				ForEach(Category.allCases) { category in
					SettingsCell(viewModel: viewModel, id: category.rawValue)
				}
			}

			buildTabItem(title: SoundTheme.title) {
				ForEach(SoundTheme.allCases) { theme in
					SettingsCell(viewModel: viewModel, id: theme.rawValue)
				}
			}

			if UIApplication.shared.supportsAlternateIcons {
				buildTabItem(title: AppIconConfiguration.title) {
					ForEach(AppIconConfiguration.allCases) { theme in
						AppIconSettingsCell(viewModel: viewModel, id: theme.rawValue)
					}
				}
			}

			buildTabItem(title: AdditionalInfo.title) {
				AdditionalInfoCell(viewModel: viewModel)
			}
		}
		.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
		.toolbarRole(.editor)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				NavButton(type: .back, action: { dismiss() })
			}

			ToolbarItem(placement: .principal) {
				DesignedText(text: Texts.Screen.Settings.title())
					.font(.title)
			}
		}
		.scrollIndicators(.automatic)
		.tabViewStyle(.page)
		.navigationBarBackButtonHidden(true)
		.navigationBarTitleDisplayMode(.inline)
	}
}

// MARK: - Private
extension SettingsList {
	func buildTabItem(
		title: String,
		content: @escaping () -> some View
	) -> some View {
		ScrollView {
			HorStack {
				DesignedText(text: title)
					.font(.title)
					.fontDesign(.monospaced)
					.padding(.top)
				Spacer()
			}
			.padding(.horizontal, Constants.padding * 2)

			VerStack(spacing: Constants.padding) {
				content()
			}
			.padding(.horizontal, Constants.padding)
		}
	}
}

#Preview {
	SettingsList(viewModel: ViewModel())
}
