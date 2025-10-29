//
//  NewsWidgetEntryView.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI

struct NewsWidgetEntryView: View {
    @Environment(\.widgetFamily) var family

    let entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        VStack {
            switch family {
            case .systemSmall: SmallView(entry: entry)
            case .accessoryCircular: AccessoryCircularView(entry: entry)
            case .accessoryInline: AccessoryInlineView(entry: entry)
            case .accessoryRectangular: AccessoryRectangularView(entry: entry)
            case .systemMedium: SystemMediumView(entry: entry)
            case .systemLarge: SystemLargeView(entry: entry)
            case .systemExtraLarge: SystemExtraLargeView(entry: entry)
            default:
                Text("Need configure")
                    .fontDesign(.monospaced)
                    .font(.headline)
            }
        }
        .transition(.push(from: .bottom))
    }
}
