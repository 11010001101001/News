//
//  ViewModel+Cache.swift
//  News
//
//  Created by Ярослав Куприянов on 05.07.2024.
//

import SwiftUI

extension ViewModel {
    func cache(object: AnyObject, key: AnyObject) {
        imageCacheData = (object, key)
    }

    func getCachedImage(key: AnyObject) -> Image? {
        cacheManager?.getCachedImage(key: key)
    }
}
