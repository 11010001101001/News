//
//  DesignedText.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 31.01.2025.
//

import Foundation
import SwiftUI

public struct DesignedText: View {
    let text: LocalizedStringResource
    
    public init(text: LocalizedStringResource) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .fontDesign(.monospaced)
    }
}
