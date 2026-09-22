//
//  ImageProvider.swift
//  News
//
//  Created by Slava on 20.09.2026.
//

import SwiftUI
import ModelsKit

struct ImageProvider {
    static let shared = ImageProvider()
    
    static func image(_ id: String) -> some View {
        if let category = NewsCategory(rawValue: id) {
            return category.image
        }
        if let loader = SoundTheme(rawValue: id) {
            return loader.image
        }
        
        return Image(systemName: "photo")
    }
}
