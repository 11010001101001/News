//
//  CacheManager.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import Foundation
import SwiftUI

protocol CacheManagerProtocol: Sendable {
    func getCachedImage(key: AnyObject) async -> Image?
    func save(object: AnyObject, key: AnyObject) async
}

actor CacheManager {
    private let cache = NSCache<AnyObject, AnyObject>()
}

// MARK: - CacheManagerProtocol
extension CacheManager: CacheManagerProtocol {
    func getCachedImage(key: AnyObject) -> Image? {
        (get(key: key) as? CachedImage)?.image
    }

    func save(object: AnyObject, key: AnyObject) {
        cache.setObject(object, forKey: key)
    }
}

// MARK: - Private
extension CacheManager {
    fileprivate func get(key: AnyObject) -> AnyObject? {
        cache.object(forKey: key)
    }
}
