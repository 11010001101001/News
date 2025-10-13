//
//  ConditionalView.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

struct NavButton: View {
    let type: NavButtonType
    let action: Action

    var body: some View {
        Button {
            action?()
        } label: {
            buildContent()
        }
    }
}

// MARK: Contents
private extension NavButton {
    @ViewBuilder
    func buildContent() -> some View {
        switch type {
        case .settings:
            NavigationLink {
                ModuleBuilder.shared.build(.settings)
            } label: {
                image
            }
        case .favorites:
            NavigationLink {
                ModuleBuilder.shared.build(.favorites)
            } label: {
                image
            }
        default:
            image
        }
    }

    var image: some View {
        Image(systemName: type.imageName)
            .tint(.primary)
            .frame(width: 24, height: 24)
    }
}
