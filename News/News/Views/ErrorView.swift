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

// MARK: - Content
private extension ErrorView {
	var errorTitle: some View {
        OptionalView(title) {
            DesignedText(text: $0)
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
        OptionalView(action) {
            CustomButton(
                action: $0,
                title: Texts.Actions.reload()
            )
        }
	}
}
