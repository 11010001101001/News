//
//  ErrorView.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import Lottie

struct ErrorView: View {
	private var title: String?
	private let action: Action
	private let startDate = Date()

	init(
		title: String? = nil,
		action: Action
	) {
		self.title = title
		self.action = action
	}

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
			.frame(width: 150, height: 150)
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

	var noiseShader: some View {
		Rectangle()
			.opacity(0.5)
			.colorEffect(ShaderLibrary.noise(.float(startDate.timeIntervalSinceNow)))
	}
}
