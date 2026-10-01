//
//  CacheManager.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import Foundation
import SwiftUI

public protocol CacheManagerProtocol {
    func get(key: AnyObject) -> AnyObject?
    func save(object: AnyObject, key: AnyObject)
}

// MARK: - CacheManagerProtocol
public class CacheManager: CacheManagerProtocol {
    private let cache = NSCache<AnyObject, AnyObject>()

    public init() {}

    public func get(key: AnyObject) -> AnyObject? {
        cache.object(forKey: key)
    }

    public func save(object: AnyObject, key: AnyObject) {
        cache.setObject(object, forKey: key)
    }
}
