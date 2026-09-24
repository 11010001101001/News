//
//  TrailingView.swift
//  News
//
//  Created by Slava on 24.09.2026.
//

import SwiftUI
import ModelsKit
import DesignSystem

struct TrailingView: View {
    let level: Level

    var body: some View {
        Text(level.image)
            .font(.caption)
            .padding(.trailing, 4)
    }
}
