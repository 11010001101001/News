//
//  AccessoryInlineView.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import DesignSystem
import Foundation
import SwiftUI

struct AccessoryInlineView: View {
    let entry: Provider.Entry

    var body: some View {
        HorStack(spacing: .zero) {
            Text(entry.level.image + .spacer)
            Text(entry.level.name)
        }
        .shadow(color: entry.level.color, radius: 7)
    }
}
