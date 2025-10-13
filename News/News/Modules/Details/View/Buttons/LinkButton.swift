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
            iconName: "link"
        )
        .modifier(
            FullScreenCoverModifier(
                viewModel: viewModel,
                webViewPresented: $webViewPresented,
                url: article.url.orEmpty
            )
        )
    }
}
