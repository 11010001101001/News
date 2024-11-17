//
//  VerStack.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

public struct VerStack<Content: View>: View {
	public let alignment: HorizontalAlignment
	public let content: () -> Content
	public let spacing: CGFloat?

	public init(
		alignment: HorizontalAlignment = .leading,
		spacing: CGFloat = .zero,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.alignment = alignment
		self.content = content
		self.spacing = spacing
	}

	public var body: some View {
		VStack(alignment: alignment, spacing: spacing) {
			content()
		}
	}
}
