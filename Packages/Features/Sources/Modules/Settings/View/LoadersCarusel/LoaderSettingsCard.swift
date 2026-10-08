//
//  LoaderSettingsCard.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import Lottie
import SwiftUI
import DesignSystem
import ModelsKit

struct LoaderSettingsCard: View {
    @Bindable var viewModel: SettingsViewModel
    let loader: LoaderConfiguration

    private var id: String {
        loader.rawValue
    }

    private var isEnabled: Bool {
        viewModel.checkIsEnabled(id)
    }

    var body: some View {
        VerStack(alignment: .center) {
            LottieView(animation: .named(id, bundle: .designSystem))
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
        .markIsSelected(viewModel.checkIsEnabled(id.lowercased()))
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.checkIsEnabled(id.lowercased())
        ) {
            viewModel.applySettings(id.lowercased())
        }
    }
}
