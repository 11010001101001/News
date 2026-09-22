//
//  CachedImage.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import SwiftUI

public final class CachedImage: Sendable {
    public let image: Image

    public init(image: Image) {
        self.image = image
    }
}
