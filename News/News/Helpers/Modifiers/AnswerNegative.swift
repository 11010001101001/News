//
//  AnswerNegative.swift
//  News
//
//  Created by Ярослав Куприянов on 12.07.2024.
//

import SwiftUI

struct AnswerNegative: ViewModifier {
	let execute: Action

	@State private var offset: CGFloat = .zero
	@State private var isAnimating = false

	func body(content: Content) -> some View {
		content
			.offset(x: offset)
			.onTapGesture {
				guard !isAnimating else { return }
				isAnimating = true
				execute?()
				offset = -3
				withAnimation(.interpolatingSpring(stiffness: 1700, damping: 8)) {
					offset = 3
				} completion: {
					offset = .zero
					isAnimating = false
				}
			}
	}
}

#Preview {
	Circle()
		.frame(width: 100, height: 100, alignment: .center)
		.modifier(AnswerNegative(execute: {}))
}
