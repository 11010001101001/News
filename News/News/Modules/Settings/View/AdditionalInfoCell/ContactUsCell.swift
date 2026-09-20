//
//  LinkCell.swift
//  News
//
//  Created by Ярослав Куприянов on 02.04.2024.
//

import SwiftUI

struct ContactUsCell: View {
    @Bindable var viewModel: SettingsViewModel
    let id: LocalizedStringResource
    let link: URL

    @Environment(\.openURL) private var openURL

    var body: some View {
        HorStack(spacing: Constants.padding) {
            Image(systemName: SFSymbols.paperplaneFill.rawValue)
                .padding(.leading, Constants.padding)
            DesignedText(text: id)
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .leading)
            Spacer()
        }
        .glassCard()
        .frame(height: 70)
        .modifier(
            OnTap(
                execute: { viewModel.impactOccured(.light) },
                completion: { openURL(link) }
            )
        )
    }
}
