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

            Text(entry.date, style: .time)
                .fontDesign(.monospaced)
                .font(.system(size: 16))
                .lineLimit(1)
        }
        .padding(.vertical)
    }
}
