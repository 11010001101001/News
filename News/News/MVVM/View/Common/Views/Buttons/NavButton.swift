//
//  ConditionalView.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

enum NavButtonType {
	case settings(isDefault: Bool)
	case markAsRead(isAllRead: Bool)
	case back
	case close

	var alignment: Alignment {
		switch self {
		case .settings, .back: .leading
		case .close, .markAsRead: .trailing
		}
	}

	var imageName: String {
		switch self {
		case let .settings(isDefault): isDefault ? "gearshape" : "gearshape.fill"
		case let .markAsRead(isAllRead): isAllRead ? "checkmark.seal.fill" : "checkmark.seal"
		case .back: "chevron.left"
		case .close: "chevron.down"
		}
	}

	var rawValue: String {
		switch self {
		case .back: "back"
		case .close: "close"
		case .markAsRead: "markAsRead"
		case .settings: "settings"
		}
	}

	var isSettings: Bool {
		rawValue == "settings"
	}
}

struct NavButton: View {
	let viewModel: ViewModel?
	let type: NavButtonType
	let action: Action

	init(
		type: NavButtonType,
		action: Action = nil,
		viewModel: ViewModel? = nil
	) {
		self.type = type
		self.action	= action
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack(alignment: type.alignment) {
			buildContent()
			ConditionalView(!type.isSettings) {
				buildTappableOverlay()
			}
		}
	}
}

// MARK: Contents
private extension NavButton {
	@ViewBuilder
	func buildContent() -> some View {
		switch type {
		case .settings:
			NavigationLink {
				if let viewModel {
					SettingsList(viewModel: viewModel)
				}
			} label: {
				image
			}
		default:
			image
		}
	}

	var image: some View {
		Image(systemName: type.imageName)
			.tint(.primary)
			.frame(width: 24, height: 24)
	}

	// Increasing tappable area
	func buildTappableOverlay() -> some View {
		Rectangle()
			.foregroundColor(Color.yellow.opacity(0.001))
			.frame(width: 70, height: 40)
			.onTapGesture { action?() }
	}
}
