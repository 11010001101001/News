//
//  AccessoryRectangularView.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import DesignSystem
import Foundation
import SwiftUI

struct AccessoryRectangularView: View {
    let entry: Provider.Entry

    var body: some View {
        VerStack(alignment: .center, spacing: 4) {
            Text(entry.category)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Divider()
                .frame(width: 70)

            HorStack {
                Text(entry.level.image + .spacer)
                Text(entry.level.name)
            }
            .font(.system(size: 20, design: .rounded))
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .lineLimit(1)
        }
        .padding(.vertical)
    }
}
