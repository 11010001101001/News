//
//  CommonInfo.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

struct CommonInfo: Decodable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}
