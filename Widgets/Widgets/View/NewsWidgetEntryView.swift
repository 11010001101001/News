//
//  NewsWidgetEntryView.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI
import WidgetKit
import DesignSystem

struct NewsWidgetEntryView: View {
    @Environment(\.widgetFamily) var family

    let entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        VerStack {
            switch family {
            case .systemSmall: SystemSmallView(entry: entry)
            case .systemMedium: SystemMediumView(entry: entry)
            case .systemLarge: SystemLargeView(entry: entry)
            case .systemExtraLarge, .systemExtraLargePortrait:
                Text("Need implement for VisionOS and Ipad")
            case .accessoryCircular: AccessoryCircularView(entry: entry)
            case .accessoryInline: AccessoryInlineView(entry: entry)
            case .accessoryRectangular: AccessoryRectangularView(entry: entry)
            @unknown default:
                Text("Need configure")
                    .fontDesign(.monospaced)
                    .font(.headline)
            }
        }
        .transition(.push(from: .bottom))
    }
}
