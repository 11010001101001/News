//
//  NewsApp.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct NewsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SettingsModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ModuleBuilder.shared.build(.main)
        }
        .modelContainer(sharedModelContainer)
    }
}
