//
//  LoaderCard.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import DesignSystem
import ModelsKit
import SwiftUI

struct LoaderCard: View {
    let viewModel: SettingsViewModel

    let loader: ShaderLoaderType

    var body: some View {
        ShaderLoader(type: loader)
            .markIsSelected(viewModel.loader == loader)
            .glassClearInteractive()
            .applyOrNotSettingsModifier(
                isEnabled: viewModel.loader == loader
            ) {
                viewModel.loader = loader
            }
    }
}
