//
//  CacheManager.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import Foundation
import SwiftUI
import Combine

protocol CacheManagerProtocol {
    func getCachedImage(key: AnyObject) -> Image?
    func bind(to publisher: AnyPublisher<(image: AnyObject, key: AnyObject)?, Never>)
}

final class CacheManager {
    private var cancellables = Set<AnyCancellable>()
    private let cache = NSCache<AnyObject, AnyObject>()
}

// MARK: - CacheManagerProtocol
extension CacheManager: CacheManagerProtocol {
    func getCachedImage(key: AnyObject) -> Image? {
        (get(key: key) as? CachedImage)?.image
    }

    func bind(to publisher: AnyPublisher<(image: AnyObject, key: AnyObject)?, Never>) {
        publisher
            .sink { [weak self] data in
                guard let data, let self else { return }
                save(object: data.image, key: data.key)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension CacheManager {
    func save(object: AnyObject, key: AnyObject) {
        cache.setObject(object, forKey: key)
    }

    func get(key: AnyObject) -> AnyObject? {
        cache.object(forKey: key)
    }
}
