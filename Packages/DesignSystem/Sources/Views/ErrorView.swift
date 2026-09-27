//
//  ErrorView.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import LocalizationKit
import SwiftUI

public struct ErrorView: View {
    var title: LocalizedStringResource?
    let action: (() -> Void)?

    public init(title: LocalizedStringResource? = nil, action: (() -> Void)?) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        HorStack {
            Spacer()
            VerStack(alignment: .center) {
                Group {
                    errorTitle
                    errorImage
                    reloadButton
                }
                .padding(Constants.padding)
            }
            .glassClearInteractive()
            Spacer()
        }
    }
}

// MARK: - Content
extension ErrorView {
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
