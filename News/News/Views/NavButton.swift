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
}

struct NavButton: View {
	let type: NavButtonType
	let action: Action

	init(
		type: NavButtonType,
		action: Action = nil,
	) {
		self.type = type
		self.action	= action
	}

	var body: some View {
        Button {
            action?()
        } label: {
            buildContent()
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
//                OptionalView(viewModel) {
//                    SettingsList(viewModel: $0)
//                }
//                ModuleBuilder.shared.build(.settings) // ? 
			} label: {
				image
			}
		default:
			image
		}
        image
	}

	var image: some View {
		Image(systemName: type.imageName)
			.tint(.primary)
			.frame(width: 24, height: 24)
	}
}
