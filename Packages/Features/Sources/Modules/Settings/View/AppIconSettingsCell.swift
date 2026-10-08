//
//  AppIconSettingsCell.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import SwiftUI
import ModelsKit
import DesignSystem

struct AppIconSettingsCell: View {
    @Bindable var viewModel: SettingsViewModel

    let theme: AppIconConfiguration

    var body: some View {
        ZStack {
            HorStack {
                Image(theme.rawValue)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                    )
                    .padding(.all, Constants.padding + 7)

                Spacer()
            }

            HorStack {
                DesignedText(theme.displayName)
                    .font(.system(size: 18, weight: .regular))
                    .padding(.leading, 130)

                Spacer()
            }
        }
        .markIsSelected(viewModel.appIcon == theme.rawValue)
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.appIcon == theme.rawValue
        ) {
            viewModel.applySettings(theme.rawValue)
        }
    }
}
