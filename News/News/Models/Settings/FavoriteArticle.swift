//
//  FavoriteArticle.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftData

@Model
final class FavoriteArticle {
    var source: FavoriteSource?
    var author: String?
    var title: String?
    var articleDescription: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?

    init(
        source: FavoriteSource? = nil,
        author: String? = nil,
        title: String? = nil,
        articleDescription: String? = nil,
        url: String? = nil,
        urlToImage: String? = nil,
        publishedAt: String? = nil,
        content: String? = nil
    ) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

// MARK: - Article
extension FavoriteArticle {
    var article: Article {
        .init(
            source: .init(id: source?.id, name: source?.name),
            author: author,
            title: title,
            description: articleDescription,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content
        )
    }
}

// MARK: - Equatable
extension FavoriteArticle: Equatable {
    static func == (lhs: FavoriteArticle, rhs: FavoriteArticle) -> Bool {
        lhs.source?.id == rhs.source?.id &&
        lhs.source?.name == rhs.source?.name &&
        lhs.author == rhs.author &&
        lhs.title == rhs.title &&
        lhs.articleDescription == rhs.articleDescription &&
        lhs.url == rhs.url &&
        lhs.urlToImage == rhs.urlToImage &&
        lhs.publishedAt == rhs.publishedAt &&
        lhs.content == rhs.content
    }
}
