//
//  ConditionalView.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

struct ConditionalView<Content: View>: View {
	let condition: Bool
	let content: () -> Content

	init(
		_ condition: Bool,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.condition = condition
		self.content = content
	}

	var body: some View {
		Group {
			if condition {
				content()
			}
		}
	}
}
