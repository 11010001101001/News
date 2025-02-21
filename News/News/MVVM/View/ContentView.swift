//
//  ContentView.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
	@Environment(ViewModel.self) private var viewModel
	@Environment(\.modelContext) var modelContext

	@Query private var savedSettings: [SettingsModel]
	@State private var imageWrapper: ContentWrapper?
	@State private var needOpenSettings = false

	var body: some View {
		TipView(SettingsTip())
			.padding()

		NavigationStack {
			TopicsList(viewModel: viewModel)
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						NavButton(type: .settings(isDefault: viewModel.isDefaultSettings), viewModel: viewModel)
					}

					ToolbarItem(placement: .principal) {
						DesignedText(text: Texts.Screen.Main.title())
							.font(.title)
					}

					ToolbarItem(placement: .topBarTrailing) {
						NavButton(type: .markAsRead(isAllRead: viewModel.isAllRead), action: viewModel.markAsReadOrUnread)
					}
				}
				.navigationBarTitleDisplayMode(.inline)
				.sheet(
					item: $imageWrapper,
					content: { content in
						ActivityViewController(contentWrapper: content)
							.presentationDetents([.medium])
					}
				)
				.navigationDestination(
					isPresented: $needOpenSettings,
					destination: { SettingsList(viewModel: viewModel) }
				)
		}
		.onAppear { onAppear() }
		.onReceive(viewModel.$shareShortcutItemTapped) { needShare in
			guard needShare else { return }
			self.imageWrapper = ContentWrapper(link: .empty, description: DeveloperInfo.shareInfo)
		}
		.onReceive(viewModel.$settingsShortcutItemTapped) { needOpen in
			guard needOpen else { return }
			needOpenSettings.toggle()
		}
		.task {
			try? Tips.configure(
				[
					.displayFrequency(.immediate),
					.datastoreLocation(.applicationDefault)
				]
			)
		}
	}
}

// MARK: - Helpers & Settings
private extension ContentView {
	func onAppear() {
		loadSettings()
		viewModel.loadNews()
		viewModel.configureNotifications()
	}

	func loadSettings() {
		if savedSettings.isEmpty {
			let defaultModel = SettingsModel(
				category: Constants.DefaultSettings.category,
				soundTheme: Constants.DefaultSettings.soundTheme,
				loader: Constants.DefaultSettings.loader,
				appIcon: Constants.DefaultSettings.appIcon
			)
			modelContext.insert(defaultModel)
			try? modelContext.save()
			viewModel.savedSettings = [defaultModel]
		} else {
			viewModel.savedSettings = savedSettings
		}

		viewModel.redrawContentViewLoader()
	}
}

#Preview {
	ContentView()
		.modelContainer(for: SettingsModel.self, inMemory: true)
}
