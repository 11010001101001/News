//
//  FavoriteArticle.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftData

@Model
public final class FavoriteArticle {
    public var source: FavoriteSource?
    public var author: String?
    public var title: String?
    public var articleDescription: String?
    public var url: String?
    public var urlToImage: String?
    public var publishedAt: String?
    public var content: String?

    public init(
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
    convenience init(article: Article) {
        self.init(
            source: .init(id: article.source?.id, name: article.source?.name),
            author: article.author,
            title: article.title,
            articleDescription: article.description,
            url: article.url,
            urlToImage: article.urlToImage,
            publishedAt: article.publishedAt,
            content: article.content
        )
    }

    public var article: Article {
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
    public static func == (lhs: FavoriteArticle, rhs: FavoriteArticle) -> Bool {
        lhs.source?.id == rhs.source?.id && lhs.source?.name == rhs.source?.name
            && lhs.author == rhs.author && lhs.title == rhs.title
            && lhs.articleDescription == rhs.articleDescription && lhs.url == rhs.url
            && lhs.urlToImage == rhs.urlToImage && lhs.publishedAt == rhs.publishedAt
            && lhs.content == rhs.content
    }
}
