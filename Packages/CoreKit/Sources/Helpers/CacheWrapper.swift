//
//  CacheWrapper.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import SwiftUI

public final class CacheWrapper<T> {
    public let data: T

    public init(data: T) {
        self.data = data
    }
}
