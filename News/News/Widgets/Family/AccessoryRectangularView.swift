//
//  AccessoryRectangularView.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI

struct AccessoryRectangularView: View {
    let entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.category)
                .fontDesign(.monospaced)
                .font(.system(size: 16))
                .lineLimit(1)

            Divider()
                .frame(width: 70)

            Text(entry.level.image + .spacer + entry.level.rawValue)
                .fontDesign(.monospaced)
                .font(.system(size: 16))
                .lineLimit(1)
                .shadow(color: entry.level.color, radius: 7)
        }
        .padding(.vertical)
    }
}
