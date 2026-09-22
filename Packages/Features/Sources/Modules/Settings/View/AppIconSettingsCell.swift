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
    
    private var id: String {
        theme.rawValue
    }

    private var shadowColor: Color {
        AppIconConfiguration(rawValue: id)?.shadowColor ?? .shadowHighlight
    }

    private var isEnabled: Bool {
        viewModel.checkIsEnabled(id.lowercased())
    }

    var body: some View {
        ZStack {
            HorStack {
                Image(id)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                    )
                    .gloss(isEnabled: isEnabled, color: shadowColor, isBorderHighlighted: true)
                    .padding(.all, Constants.padding + 7)

                Spacer()
            }

            HorStack {
                DesignedText(text: theme.displayName)
                    .font(.system(size: 18, weight: .regular))
                    .padding(.leading, 130)

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
