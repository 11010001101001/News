//
//  ConditionalView.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

public struct ConditionalView<Content: View>: View {
    let condition: Bool
    let content: () -> Content

    public init(
        _ condition: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.condition = condition
        self.content = content
    }

    public var body: some View {
        if condition {
            content()
        }
    }
}
