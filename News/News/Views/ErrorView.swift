//
//  ErrorView.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import Lottie

struct ErrorView: View {
	var title: String?
	let action: Action
	let startDate = Date()

    var body: some View {
        VerStack(alignment: .center) {
            Group {
                errorTitle
                errorImage
                reloadButton
            }
            .padding(Constants.padding)
        }
        .glassCard()
    }
}

// MARK: - Private
private extension ErrorView {
	var errorTitle: some View {
		ConditionalView(title != nil) {
			DesignedText(text: title ?? .empty)
				.labelStyle(.titleOnly)
				.foregroundStyle(.white)
				.multilineTextAlignment(.center)
				.font(.headline)
				.fixedSize(horizontal: false, vertical: true)
				.padding(.horizontal, CGFloat.sideInsets)
		}
	}

	var errorImage: some View {
		Image(uiImage: .errorCat)
			.resizable()
			.frame(width: 170, height: 170)
			.gloss(numberOfLayers: 1)
			.scaledToFill()
			.padding(.horizontal)
	}

	var reloadButton: some View {
		CustomButton(
			action: action,
			title: Texts.Actions.reload()
		)
	}
}
