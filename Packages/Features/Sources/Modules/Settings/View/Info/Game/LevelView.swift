//
//  LevelView.swift
//  News
//
//  Created by Ярослав Куприянов on 29.20.2025.
//

import DesignSystem
import Foundation
import LocalizationKit
import SwiftUI
import ModelsKit

struct LevelView: View {
    let entry: Entry

    var body: some View {
        HorStack(spacing: 8) {
            LevelCard(entry: entry)
            categoryCard
        }
        .frame(minWidth: 120, maxHeight: .infinity, alignment: .leading)
        .padding(Constants.padding)
    }

    var categoryCard: some View {
        VerStack(spacing: 6) {
            Circle()
                .fill(entry.level.color)
                .frame(width: 12, height: 12)
                .shadow(color: entry.level.color.opacity(0.8), radius: 6, x: 0, y: 0)

            Spacer()

            Text(Strings.widgetsCategory)
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text(entry.category)
                .font(.system(.callout, design: .rounded))
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .padding()
        .frame(minWidth: 120, maxHeight: .infinity, alignment: .leading)
        .background(.black.opacity(0.25), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
