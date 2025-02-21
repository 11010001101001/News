//
//  LoaderSettingsCell.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import SwiftUI
import Lottie

struct AppIconSettingsCell: View {
    @ObservedObject private var viewModel: ViewModel
    private let id: String

	private var shadowColor: Color {
		AppIconConfiguration(rawValue: id)?.shadowColor ?? .shadowHighlight
	}

    private var isEnabled: Bool {
        viewModel.checkIsEnabled(id.lowercased())
    }

	init(viewModel: ViewModel, id: String) {
		self.viewModel = viewModel
		self.id = id
	}

    var body: some View {
        ZStack {
            HorStack {
				Image(id)
					.resizable()
					.frame(width: 80, height: 80)
					.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
					.gloss(isEnabled: isEnabled, color: shadowColor, isBorderHighlighted: true)
					.padding(.all, Constants.padding + 7)

                Spacer()
            }

			HorStack {
                DesignedText(text: id.capitalizingFirstLetter())
                    .font(.system(size: 18, weight: .regular))
                    .padding(.leading, 130)

                Spacer()
            }
        }
        .card()
        .markIsSelected(viewModel, id)
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.checkIsEnabled(id.lowercased())
        ) {
            viewModel.applySettings(id.lowercased())
        }
    }
}

#Preview {
	AppIconSettingsCell(viewModel: ViewModel(), id: AppIconConfiguration.globe.rawValue)
}
