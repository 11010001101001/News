//
//  View+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import Foundation
import SwiftUI

extension View {
	func glassCard() -> some View {
		self
            .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
	}

	func any() -> AnyView {
		AnyView(self)
	}

	func applyOrNotSettingsModifier(
		isEnabled: Bool,
		execute: Action
	) -> some View {
		isEnabled ?
		self.modifier(AnswerNegative(execute: execute)).any() :
		self.modifier(OnTap(execute: nil, completion: execute)).any()
	}

	func markAsReadOrHighlight(
		_ viewModel: ViewModel,
		_ article: Article
	) -> some View {
		let isRead = viewModel.checkIsRead(article.key)
		let opacity = isRead ? 0.5 : 1.0
		let isShadowEnabled = (article.title?.lowercased() ?? .empty).contains("apple")

		return switch (isRead, isShadowEnabled) {
		case (false, false):
			self.any()
		case (true, false):
			self.opacity(opacity).any()
		case (true, true):
			self.opacity(opacity).any()
		case (false, true):
			if isShadowEnabled {
				self.modifier(InnerShadowProvider()).any()
			} else {
				self.any()
			}
		}
	}

	func markIsSelected(
		_ viewModel: ViewModel,
		_ id: String
	) -> some View {
		let isEnabled = viewModel.checkIsEnabled(id.lowercased())
		guard isEnabled else { return self.any() }
		return self.modifier(InnerShadowProvider()).any()
	}

	func gloss(
		isEnabled: Bool = true,
		color: Color = .shadowHighlight,
		radius: CGFloat = 10.0,
		numberOfLayers: Int = 4,
		isBorderHighlighted: Bool = false
	) -> some View {
		guard isEnabled else { return self.any() }

		return self
			.overlay {
				ZStack {
					ForEach(0..<numberOfLayers) { _ in
						self
							.shadow(
								color: color,
								radius: radius
							)
					}

					ConditionalView(isBorderHighlighted) {
						ForEach(0..<5) { _ in
							self
								.shadow(
									color: .white,
									radius: 2
								)
						}
					}
				}
			}
			.any()
	}
}
