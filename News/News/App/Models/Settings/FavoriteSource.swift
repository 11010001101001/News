//
//  FavoriteSource.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftData

@Model
final class FavoriteSource {
    var id: String?
    var name: String?

    init(
        id: String? = nil,
        name: String? = nil
    ) {
        self.id = id
        self.name = name
    }
}
