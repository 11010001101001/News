//
//  Source.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

public struct Source: Decodable, Equatable, Hashable, Sendable {
    public var id: String?
    public var name: String?
}
