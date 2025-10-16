//
//  Optional+Extensions.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 06.02.2025.
//

import Foundation

extension Optional where Wrapped == String {
	var orEmpty: String {
		self ?? .empty
	}

	func or(_ defaultValue: String) -> String {
		if let self, self.isEmpty {
			return defaultValue
		}
		return self ?? defaultValue
	}
}

extension Optional where Wrapped == Set<String> {
    var orEmpty: Set<String> {
        self ?? []
    }
}

extension Optional where Wrapped == [Article] {
    var orEmpty: [Article] {
        self ?? []
    }
}

extension Optional where Wrapped == [FavoriteArticle] {
    var orEmpty: [FavoriteArticle] {
        self ?? []
    }
}
