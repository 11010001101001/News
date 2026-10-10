//
//  LoaderCard.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import DesignSystem
import Lottie
import ModelsKit
import SwiftUI

struct LoaderCard: View {
    @Bindable var viewModel: SettingsViewModel

    let loader: LoaderConfiguration

    var body: some View {
        VerStack(alignment: .center) {
            LottieView(animation: .named(loader.rawValue, bundle: .designSystem))
                .playing(loopMode: .loop)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            DesignedText(loader.displayName)
                .font(.callout)
                .foregroundStyle(.gray)
                .padding(Constants.padding)
        }
        .markIsSelected(viewModel.loader == loader)
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.loader == loader
        ) {
            viewModel.loader = loader
        }
    }
}
