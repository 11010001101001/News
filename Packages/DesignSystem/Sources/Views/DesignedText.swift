//
//  DesignedText.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 31.01.2025.
//

import Foundation
import SwiftUI

public struct DesignedText: View {
    private let text: LocalizedStringResource

    public init(_ text: LocalizedStringResource) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .fontDesign(.rounded)
    }
}
