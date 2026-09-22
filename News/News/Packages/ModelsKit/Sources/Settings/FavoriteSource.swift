//
//  FavoriteSource.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftData

@Model
public final class FavoriteSource {
    public var id: String?
    public var name: String?

    public init(
        id: String? = nil,
        name: String? = nil
    ) {
        self.id = id
        self.name = name
    }
}
