//
//  Mode.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

enum Mode {
    case keyword(_: String)
    case category(_: String)

    //swiftlint:disable all
    var urlString: String {
        switch self {
        case .keyword(let keyword):
            "https://newsapi.org/v2/everything?q=\(keyword)&pageSize=\(Constants.newsCount)&language=ru&apiKey=\(DeveloperInfo.apiKey)"
        case .category(let category):
            "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&pageSize=\(Constants.newsCount)&apiKey=\(DeveloperInfo.apiKey)"
        }
    }
    //swiftlint:enable all
}
