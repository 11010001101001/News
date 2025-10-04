//
//  VerStack.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

struct VerStack<Content: View>: View {
	let alignment: HorizontalAlignment
	let content: () -> Content
	let spacing: CGFloat?

	init(
		alignment: HorizontalAlignment = .leading,
		spacing: CGFloat = .zero,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.alignment = alignment
		self.content = content
		self.spacing = spacing
	}

	var body: some View {
		VStack(alignment: alignment, spacing: spacing) {
			content()
		}
	}
}
