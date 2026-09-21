//
//  AccessoryInlineView.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI

struct AccessoryInlineView: View {
    let entry: Provider.Entry

    var body: some View {
        HStack(spacing: .zero) {
            Text(entry.level.image + .spacer + entry.level.rawValue)
                .shadow(color: entry.level.color, radius: 7)
        }
    }
}
