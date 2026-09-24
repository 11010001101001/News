//
//  ButtonMetaData.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation

public struct ButtonMetaData {
    public let article: Article
    public let title: LocalizedStringResource?
    public let iconName: String

    public init(article: Article, title: LocalizedStringResource?, iconName: String) {
        self.article = article
        self.title = title
        self.iconName = iconName
    }
}
