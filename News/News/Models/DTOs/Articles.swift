//
//  Articles.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

struct Article: Decodable, Equatable, Hashable {
    var key: String {
        let saltNumber = 7
        return (title ?? .empty) + String(description ?? .empty).prefix(saltNumber)
    }

    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

extension Article {
    var favorite: FavoriteArticle {
        .init(
            source: .init(id: source?.id, name: source?.name),
            author: author,
            title: title,
            articleDescription: description,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content
        )
    }
}
