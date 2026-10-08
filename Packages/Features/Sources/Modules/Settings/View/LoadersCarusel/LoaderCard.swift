//
//  LoaderCard.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import Lottie
import SwiftUI
import DesignSystem
import ModelsKit

struct LoaderCard: View {
    @Bindable var viewModel: SettingsViewModel

    let loader: LoaderConfiguration

    var body: some View {
        VerStack(alignment: .center) {
            LottieView(animation: .named(loader.rawValue, bundle: .designSystem))
                .playing(loopMode: .loop)
                .frame(
                    width: Constants.loaderCardSize.width,
                    height: Constants.loaderCardSize.height
                )

            DesignedText(loader.displayName)
                .font(.callout)
                .foregroundStyle(.gray)
                .padding(Constants.padding)
        }
        .markIsSelected(viewModel.loader == loader.rawValue)
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.loader == loader.rawValue
        ) {
            viewModel.applySettings(loader.rawValue)
        }
    }
}
