//
//  Category.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
    var id: Self { return self }

    static var title: String { String(describing: self) }

    static var random: String {
        Category.allCases.randomElement()?.rawValue ?? ""
    }

    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}
