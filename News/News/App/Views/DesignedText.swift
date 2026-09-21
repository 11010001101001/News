//
//  DesignedText.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 31.01.2025.
//

import Foundation
import SwiftUI

struct DesignedText: View {
    let text: LocalizedStringResource
    
    init(text: LocalizedStringResource) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .fontDesign(.monospaced)
    }
}
