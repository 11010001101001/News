//
//  AppIconCard.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import DesignSystem
import ModelsKit

struct AppIconCard: View {
    let viewModel: SettingsViewModel
    let appIcon: AppIconConfiguration

    var body: some View {
        VerStack(alignment: .center, spacing: 8) {
            Image(appIcon.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(.rect(cornerRadius: 13.5, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 13.5, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )

            DesignedText(appIcon.displayName)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .frame(height: 130)
        .frame(maxWidth: .infinity)
        .markIsSelected(viewModel.appIcon == appIcon.rawValue)
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.appIcon == appIcon.rawValue
        ) {
            viewModel.applySettings(appIcon.rawValue)
        }
    }
}
