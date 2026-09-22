//
//  NewsApp.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftData
import SwiftUI
import TipKit
import ModelsKit
import Features

@main
struct NewsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([SettingsModel.self])

        let configuration = ModelConfiguration(
            "Default",
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier("group.news2.0.News")
        )

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            if let inMemoryContainer = try? ModelContainer(
                for: schema, configurations: [fallbackConfig])
            {
                return inMemoryContainer
            }
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ModuleBuilder.shared.build(.main)
                .modelContainer(sharedModelContainer)
        }
    }
}
