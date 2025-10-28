//
//  LinkButton.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI

struct LinkButton: View {
    @State private var webViewPresented = false

    let viewModel: DetailsViewModel
    let article: Article

    var body: some View {
        CustomButton(
            action: {
                viewModel.impactOccured(.light)
                webViewPresented.toggle()
            },
            title: nil,
            iconName: SFSymbols.link.rawValue
        )
        .modifier(
            WebViewSheetModifier(
                viewModel: viewModel,
                webViewPresented: $webViewPresented,
                url: article.url.orEmpty
            )
        )
    }
}
