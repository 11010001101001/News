//
//  WidgetsManager.swift
//  News
//
//  Created by Ярослав Куприянов on 02.11.2025.
//

import ActivityKit
import CoreKit
import Foundation
import ModelsKit
import WidgetKit

public protocol WidgetsManagerProtocol {
    func updateLevel(watchedTopics: Set<String>)
    func start()
    func updateArticles(_ articles: [Article])
}

final class WidgetsManager: WidgetsManagerProtocol, @unchecked Sendable {
    private enum Actions {
        case start
        case updateArticles(_ articles: [Article])
        case updateLevel(_ watchedTopics: Set<String>)
    }

    private var articles = [Article]()
    private let stream: AsyncStream<Actions>
    private let continuation: AsyncStream<Actions>.Continuation

    init() {
        let (stream, continuation) = AsyncStream.makeStream(of: Actions.self)
        self.stream = stream
        self.continuation = continuation

        Task { [weak self, stream] in
            for await action in stream {
                guard let self else { return }
                await self.process(action)
            }
        }
    }

    func start() {
        continuation.yield(.start)
    }

    func updateArticles(_ articles: [Article]) {
        continuation.yield(.updateArticles(articles))
    }

    func updateLevel(watchedTopics: Set<String>) {
        continuation.yield(.updateLevel(watchedTopics))
    }

    private func process(_ action: Actions) async {
        switch action {
        case .start:
            await handleStart()
        case .updateArticles(let articles):
            self.articles = articles
        case .updateLevel(let watchedTopics):
            await handleUpdateLevel(watchedTopics: watchedTopics)
        }
    }

    private func handleStart() async {
        for activity in Activity<NewsWidgetsAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        _ = try? Activity<NewsWidgetsAttributes>.request(
            attributes: NewsWidgetsAttributes(),
            content: .init(
                state: NewsWidgetsAttributes.ContentState(level: .newbie, procents: .zero),
                staleDate: Date().hour
            ),
            pushType: nil
        )
    }

    private func handleUpdateLevel(watchedTopics: Set<String>) async {
        guard !articles.isEmpty else { return }

        let watched = articles.filter { article in
            watchedTopics.contains(where: { $0 == article.key })
        }

        let procents = watched.count * 100 / articles.count
        let level = Level.getLevel(for: procents)
        let newState = NewsWidgetsAttributes.ContentState(level: level, procents: procents)

        let activeActivity = Activity<NewsWidgetsAttributes>.activities.first {
            $0.activityState == .active
        }

        guard let activeActivity else {
            await handleStart()
            await handleUpdateLevel(watchedTopics: watchedTopics)
            return
        }

        let content = ActivityContent(state: newState, staleDate: Date().hour)
        await activeActivity.update(content)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
