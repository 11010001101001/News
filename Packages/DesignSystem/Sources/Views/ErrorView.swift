//
//  ErrorView.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import LocalizationKit
import SwiftUI

public struct ErrorView: View {
    private let title: LocalizedStringResource?
    private let action: (() -> Void)?
    private let isCard: Bool

    public init(title: LocalizedStringResource? = nil, action: (() -> Void)?, isCard: Bool = false) {
        self.title = title
        self.action = action
        self.isCard = isCard
    }

    public var body: some View {
        HorStack {
            Spacer()
            if isCard {
                content
                    .glassClearInteractive()
            } else {
                content
            }
            Spacer()
        }
    }
}

// MARK: - Content
extension ErrorView {
    fileprivate var content: some View {
        VerStack(alignment: .center) {
            Group {
                errorTitle
                errorImage
                reloadButton
            }
            .padding(Constants.padding)
        }
    }

    fileprivate var errorTitle: some View {
        OptionalView(title) {
            DesignedText($0)
                .labelStyle(.titleOnly)
                .multilineTextAlignment(.center)
                .font(.headline)
        }
    }

    fileprivate var errorImage: some View {
        Images.errorCat
            .resizable()
            .frame(width: 170, height: 170)
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
