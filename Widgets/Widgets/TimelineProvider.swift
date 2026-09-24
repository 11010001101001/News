//
//  TimelineProvider.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftData
import WidgetKit
import ModelsKit
import CoreKit
import LocalizationKit

struct Provider: TimelineProvider {
    let container = try? ModelContainer(
        for: Schema([SettingsModel.self]),
        configurations: [
            ModelConfiguration(
                "Default",
                groupContainer: .identifier("group.news2.0.News")
            )
        ]
    )

    func placeholder(in context: Context) -> Entry {
        Entry(category: "", level: .newbie, procentsToNextLevel: 0, lastViewedTitle: .empty)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry(category: Strings.widgetsCategory, level: .newbie, procentsToNextLevel: 0, lastViewedTitle: .empty)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            guard
                let settings = try? await loadSettings(),
                let (level, procentsToNextLevel) = try? await getUserLevel(settings)
            else { return }

            let entry = Entry(
                category: NewsCategory.init(rawValue: settings.category)!.displayName,
                level: level,
                procentsToNextLevel: procentsToNextLevel,
                lastViewedTitle: settings.lastViewedTitle.orEmpty
            )

            guard
                let nextUpdate = Calendar.current.date(
                    byAdding: DateComponents(minute: 180), to: Date())
            else { return }

            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    func getUserLevel(_ settings: SettingsModel?) async throws -> (Level, Int)? {
        guard let category = settings?.category else { return (.newbie, 0) }

        let link =
            "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&pageSize=100&apiKey=8f825354e7354c71829cfb4cb15c4893"

        guard let url = URL(string: link),
            let watchedTopics = settings?.watchedTopics
        else {
            return (.newbie, 0)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let model = try JSONDecoder().decode(CommonInfo.self, from: data)
        let articles = model.articles.orEmpty
        let watched = articles.filter { article in
            watchedTopics.contains(where: { $0 == article.key })
        }

        let procents = watched.count * 100 / articles.count
        let level = Level.getLevel(for: procents)
        let procentsToNextLevel = procents * 100 / level.maxLevelProcent()
        return (level, procentsToNextLevel)
    }

    @MainActor
    func loadSettings() async throws -> SettingsModel? {
        guard let container else { return nil }
        let context = container.mainContext
        let settings = try? context.fetch(FetchDescriptor<SettingsModel>())
        return settings?.first
    }
}
