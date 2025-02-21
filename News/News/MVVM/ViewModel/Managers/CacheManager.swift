//
//  CacheManager.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import Foundation
import SwiftUI
import Combine

final class CacheManager {
    private var imageCancellable: AnyCancellable?
    private let cache = NSCache<AnyObject, AnyObject>()

    init(viewModel: ViewModel) {
        imageCancellable = viewModel.$imageCacheData
            .sink { [weak self] data in
                guard let data, let self else { return }
                save(object: data.image, key: data.key)
            }
    }

    deinit {
        imageCancellable = nil
    }
}

extension CacheManager {
    private func save(object: AnyObject, key: AnyObject) {
        cache.setObject(object, forKey: key)
    }

    private func get(key: AnyObject) -> AnyObject? {
        cache.object(forKey: key)
    }
}

extension CacheManager {
    func getCachedImage(key: AnyObject) -> Image? {
        (get(key: key) as? CachedImage)?.image
    }
}
