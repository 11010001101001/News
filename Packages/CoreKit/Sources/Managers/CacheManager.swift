//
//  CacheManager.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import Foundation
import SwiftUI

public protocol CacheManagerProtocol: Sendable {
    func getCachedImage(key: AnyObject & Sendable) async -> Image?
    func save(object: AnyObject & Sendable, key: AnyObject & Sendable) async
}

// MARK: - CacheManagerProtocol
public actor CacheManager: CacheManagerProtocol {
    private let cache = NSCache<AnyObject, AnyObject>()

    public init() { }

    public func getCachedImage(key: AnyObject & Sendable) -> Image? {
        (get(key: key) as? CachedImage)?.image
    }

    public func save(object: AnyObject & Sendable, key: AnyObject & Sendable) {
        cache.setObject(object, forKey: key)
    }
}

// MARK: - Private
extension CacheManager {
    fileprivate func get(key: AnyObject) -> AnyObject? {
        cache.object(forKey: key)
    }
}
