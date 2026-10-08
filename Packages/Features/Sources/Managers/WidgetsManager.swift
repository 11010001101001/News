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
    func getUserLevel(_ watchedTopics: Set<String>?) -> (level: Level, progressInLevel: Int)
}

final class WidgetsManager: WidgetsManagerProtocol, @unchecked Sendable {
    fileprivate enum Actions {
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
}

// MARK: Public
extension WidgetsManager {
    func start() {
        continuation.yield(.start)
    }

    func updateArticles(_ articles: [Article]) {
        continuation.yield(.updateArticles(articles))
    }

    func updateLevel(watchedTopics: Set<String>) {
        continuation.yield(.updateLevel(watchedTopics))
    }

    func getUserLevel(_ watchedTopics: Set<String>?) -> (level: Level, progressInLevel: Int) {
        guard let watchedTopics, !articles.isEmpty else { return (.newbie, 0) }

        let watched = articles.filter { article in
            watchedTopics.contains(where: { $0 == article.key })
        }

        let procents = watched.count * 100 / articles.count
        let level = Level.getLevel(for: procents)
        return (level, level.progressInLevel(for: procents))
    }
}

// MARK: Private
extension WidgetsManager {
    fileprivate func process(_ action: Actions) async {
        switch action {
        case .start:
            await handleStart()
        case .updateArticles(let articles):
            self.articles = articles
        case .updateLevel(let watchedTopics):
            await handleUpdateLevel(watchedTopics: watchedTopics)
        }
    }

    fileprivate func handleStart() async {
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

    fileprivate func handleUpdateLevel(watchedTopics: Set<String>) async {
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
