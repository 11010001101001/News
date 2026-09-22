//
//  ErrorView.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import LocalizationKit

public struct ErrorView: View {
    var title: LocalizedStringResource?
    let action: (() -> Void)?
    
    public init(title: LocalizedStringResource? = nil, action: (() -> Void)?) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        VerStack(alignment: .center) {
            Group {
                errorTitle
                errorImage
                reloadButton
            }
            .padding(Constants.padding)
        }
        .glassCard()
    }
}

// MARK: - Content
extension ErrorView {
    fileprivate var errorTitle: some View {
        OptionalView(title) {
            DesignedText(text: $0)
                .labelStyle(.titleOnly)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, CGFloat.sideInsets)
        }
    }

    fileprivate var errorImage: some View {
        Images.errorCat
            .resizable()
            .frame(width: 170, height: 170)
            .gloss(numberOfLayers: 1)
            .scaledToFill()
            .padding(.horizontal)
    }

    fileprivate var reloadButton: some View {
        OptionalView(action) {
            CustomButton(
                action: $0,
                title: Strings.actionsReload
            )
        }
    }
}
