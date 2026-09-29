//
//  LinkButton.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI
import ModelsKit
import DesignSystem
import LocalizationKit

struct LinkButton: View {
    @State private var webViewPresented = false

    let viewModel: DetailsViewModel

    var body: some View {
        CustomButton(
            action: {
                viewModel.impactOccured(.light)
                webViewPresented.toggle()
            },
            title: nil,
            iconName: SFSymbols.safari.rawValue,
            isGlass: false
        )
        .modifier(
            WebViewSheetModifier(
                viewModel: viewModel,
                webViewPresented: $webViewPresented,
                url: viewModel.url
            )
        )
    }
}
