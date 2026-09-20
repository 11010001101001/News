//
//  MainView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import SwiftData
import SwiftUI
import TipKit

struct MainView: View {
    @Environment(\.scenePhase) var phase
    @Environment(\.modelContext) var modelContext

    @State var viewModel: MainViewModel

    @State private var imageWrapper: ContentWrapper?
    @State private var needOpenSettings = false
    @Query private var savedSettings: [SettingsModel]

    var body: some View {
        content
            .environment(\.locale, Locale(identifier: savedSettings.first?.language ?? Constants.DefaultSettings.language))
    }
}

// MARK: - Content
extension MainView {
    @ViewBuilder
    fileprivate var content: some View {
        TipView(SettingsTip())
            .padding()
        NavigationStack {
            TopicsList(viewModel: viewModel)
                .navbar()
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
                    destination: { ModuleBuilder.shared.build(.settings) }
                )
        }
        .onAppear { onAppear() }
        .onChange(of: viewModel.shareShortcutItemTapped) { _, needShare in
            guard needShare else { return }
            self.imageWrapper = ContentWrapper(link: .empty, description: DeveloperInfo.shareInfo)
        }
        .onChange(of: viewModel.settingsShortcutItemTapped) { _, needOpen in
            guard needOpen else { return }
            needOpenSettings.toggle()
        }
        .task {
            configureTips()
        }
        .onChange(of: phase) { _, phase in
            handleScenePhase(phase)
        }
    }
}

// MARK: - Private
extension MainView {
    fileprivate func onAppear() {
        loadSettings()
        viewModel.loadNews()
        viewModel.configureNotifications()
    }

    fileprivate func loadSettings() {
        if savedSettings.isEmpty {
            let defaultModel = SettingsModel()
            modelContext.insert(defaultModel)
            try? modelContext.save()
            viewModel.loadSettings([defaultModel])
        } else {
            viewModel.loadSettings(savedSettings)
        }
    }

    fileprivate func handleScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .active:
            if let itemName = ShortcutItem.selectedAction?.userInfo?["name"] as? String {
                viewModel.handleShortcutItemTap(itemName)
            }
        case .background:
            viewModel.addShortcutItems()
        case .inactive:
            break
        @unknown default:
            assertionFailure("Unknown default phase: \(phase)")
        }
    }

    fileprivate func configureTips() {
        try? Tips.configure(
            [
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault),
            ]
        )
    }
}

// MARK: - Navigation bar
extension TopicsList {
    fileprivate func navbar() -> some View {
        self.toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavButton(type: .settings(isDefault: viewModel.isDefaultSettings), action: nil)
            }

            ToolbarItem(placement: .principal) {
                HorStack(spacing: 16) {
                    Text(">>")
                    DesignedText(text: NewsCategory.init(rawValue: viewModel.category)!.localizedResource)
                    Spacer()
                }
                .font(.title)
            }

            ToolbarItem(placement: .topBarTrailing) {
                NavButton(type: .favorites(hasFavorites: viewModel.hasFavorites), action: nil)
            }

            ToolbarItem(placement: .topBarTrailing) {
                NavButton(
                    type: .markAsRead(isAllRead: viewModel.isAllRead),
                    action: viewModel.markAsReadOrUnread
                )
            }
        }
    }
}
