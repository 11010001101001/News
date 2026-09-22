//
//  LoaderSettingsCell.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import Lottie
import SwiftUI
import DesignSystem
import ModelsKit

struct LoaderSettingsCell: View {
    @Bindable var viewModel: SettingsViewModel
    let loader: LoaderConfiguration
    
    private var id: String {
        loader.rawValue
    }

    private var isEnabled: Bool {
        viewModel.checkIsEnabled(id)
    }

    var body: some View {
        ZStack {
            HorStack {
                LottieView(animation: .named(id))
                    .playing(loopMode: .loop)
                    .gloss(
                        isEnabled: isEnabled, color: viewModel.loaderShadowColor,
                        isBorderHighlighted: true
                    )
                    .frame(width: 150, height: 100)
                    .padding(.leading, -20)

                Spacer()
            }

            HorStack {
                DesignedText(text: loader.displayName)
                    .font(.system(size: 18, weight: .regular))
                    .padding(.leading, 100)

                Spacer()
            }
        }
        .glassCard()
        .markIsSelected(viewModel, id)
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.checkIsEnabled(id.lowercased())
        ) {
            viewModel.applySettings(id.lowercased())
        }
    }
}
