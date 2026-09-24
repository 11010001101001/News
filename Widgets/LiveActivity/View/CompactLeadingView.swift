//
//  CompactLeadingView.swift
//  News
//
//  Created by Slava on 24.09.2026.
//

import SwiftUI
import ModelsKit
import DesignSystem

struct CompactLeadingView: View {
    let level: Level

    var body: some View {
        HorStack {
            Circle()
                .fill(level.color)
                .frame(width: 8, height: 8)
                .shadow(color: level.color.opacity(0.8), radius: 4)
                .padding(.leading, 4)
            Color.red.opacity(0.01)
                .frame(width: 8, height: 8)
        }
    }
}
