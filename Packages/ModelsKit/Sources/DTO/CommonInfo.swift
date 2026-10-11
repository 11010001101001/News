//
//  CommonInfo.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

public struct CommonInfo: Decodable {
    public var status: String?
    public var totalResults: Int?
    public var articles: [Article]?
}
