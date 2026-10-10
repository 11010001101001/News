//
//  Articles.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

public struct Article: Equatable, Hashable, Sendable, Codable {
    public var key: String {
        let saltNumber = 10
        let title = self.title.orEmpty.prefix(saltNumber)
        let description = self.description.orEmpty.prefix(saltNumber)
        let url = self.url.orEmpty.prefix(saltNumber)
        let date = self.publishedAt.orEmpty.prefix(saltNumber)
        return String(title + description + url + date)
    }

    public var source: Source?
    public var author: String?
    public var title: String?
    public var description: String?
    public var url: String?
    public var urlToImage: String?
    public var publishedAt: String?
    public var content: String?
}

extension Optional where Wrapped == [Article] {
    public var orEmpty: [Article] {
        self ?? []
    }
}
