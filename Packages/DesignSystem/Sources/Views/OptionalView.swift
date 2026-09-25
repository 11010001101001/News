//
//  OptionalView.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.11.2024.
//

import Foundation
import SwiftUI

public struct OptionalView<T, Content: View>: View {
    let optional: T?
    let content: (T) -> Content

    public init(
        _ optional: T?,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.optional = optional
        self.content = content
    }

    public var body: some View {
        if let optional {
            content(optional)
        }
    }
}
