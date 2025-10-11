//
//  OptionalView.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

struct OptionalView<T, Content: View>: View {
	let optional: Optional<T>
	let content: (T) -> Content

	init(
		_ optional: T,
		@ViewBuilder content: @escaping (T) -> Content
	) {
        self.optional = optional
		self.content = content
	}

	var body: some View {
		Group {
			if let optional {
				content(optional)
			}
		}
	}
}
