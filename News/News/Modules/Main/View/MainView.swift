//
//  MainView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import SwiftUI
import TipKit
import SwiftData

struct MainView: View {
    @Environment(\.scenePhase) var phase
    @Environment(\.modelContext) var modelContext

    @StateObject var viewModel: MainViewModel

    @State private var imageWrapper: ContentWrapper?
    @State private var needOpenSettings = false
    @Query private var savedSettings: [SettingsModel]

    var body: some View {
        content
    }
}

// MARK: - Content
private extension MainView {
    @ViewBuilder
    var content: some View {
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
        .onReceive(viewModel.$shareShortcutItemTapped) { needShare in
            guard needShare else { return }
            self.imageWrapper = ContentWrapper(link: .empty, description: DeveloperInfo.shareInfo)
        }
        .onReceive(viewModel.$settingsShortcutItemTapped) { needOpen in
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
private extension MainView {
    func onAppear() {
        loadSettings()
        viewModel.loadNews()
        viewModel.configureNotifications()
    }

    func loadSettings() {
        if savedSettings.isEmpty {
            let defaultModel = SettingsModel()
            modelContext.insert(defaultModel)
            try? modelContext.save()
            viewModel.loadSettings([defaultModel])
        } else {
            viewModel.loadSettings(savedSettings)
        }

        viewModel.redrawContentViewLoader()
    }

    func handleScenePhase(_ phase: ScenePhase) {
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

    func configureTips() {
        try? Tips.configure(
            [
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ]
        )
    }
}

// MARK: - Navigation bar
private extension TopicsList {
    func navbar() -> some View {
        self.toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavButton(type: .settings(isDefault: viewModel.isDefaultSettings), action: nil)
            }

            ToolbarItem(placement: .principal) {
                DesignedText(text: Texts.Screen.Main.title())
                    .font(.title)
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
