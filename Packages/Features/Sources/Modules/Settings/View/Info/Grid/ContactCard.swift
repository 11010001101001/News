//
//  ContactCard.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import DesignSystem
import ModelsKit
import LocalizationKit

struct ContactCard: View {
    let viewModel: SettingsViewModel

    @Environment(\.openURL) private var openURL

    var body: some View {
        VerStack(alignment: .center, spacing: Constants.padding) {
            Image(systemName: SFSymbols.paperplaneFill.rawValue)
                .font(.title2)
                .foregroundStyle(.white)

            DesignedText(Strings.appContactUs)
                .font(.callout)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .glassClearInteractive()
        .modifier(
            OnTap(
                execute: { viewModel.impactOccured(.light) },
                completion: { openURL(DeveloperInfo.contactLink) }
            )
        )
    }
}
