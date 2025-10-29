//
//  TimelineProvider.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import WidgetKit
import SwiftData

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
        Entry(category: "", level: .newbie)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry(category: "Category", level: .newbie)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            let category = NewsCategory.technology.rawValue
            guard let level = try? await getUserLevel(category: category) else { return }
            let entry = Entry(category: category, level: level)
            guard let nextUpdate = Calendar.current.date(byAdding: DateComponents(minute: 180), to: Date()) else { return }
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    func getUserLevel(category: String) async throws -> Level? {
        // swiftlint:disable line_length
        let link = "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&pageSize=100&apiKey=8f825354e7354c71829cfb4cb15c4893"
        // swiftlint:enable line_length
        let settings = try? await loadSettings()

        guard let url = URL(string: link),
              let watchedTopics = settings?.watchedTopics
        else {
            return .error
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let model = try JSONDecoder().decode(CommonInfo.self, from: data)
        let articles = model.articles.orEmpty
        let watched = articles.filter { article in
            watchedTopics.contains(where: { $0 == article.key })
        }

        let procents = watched.count * 100 / articles.count
        return getLevel(for: procents)
    }

    func getLevel(for procents: Int) -> Level {
        switch procents {
        case (0..<25): .newbie
        case (25..<50): .curiousObserver
        case (50..<75): .loopMaster
        case (75..<100): .techNinja
        default: .unrecognized
        }
    }

    @MainActor
    func loadSettings() async throws -> SettingsModel? {
        guard let container else { return nil }
        let context = container.mainContext
        let settings = try? context.fetch(FetchDescriptor<SettingsModel>())
        return settings?.first
    }
}
