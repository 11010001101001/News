//
//  Articles.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

struct Article: Decodable, Identifiable {
    var id: UUID? {
        UUID()
    }

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
