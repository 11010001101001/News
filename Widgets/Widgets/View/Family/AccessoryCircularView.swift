//
//  AccessoryCircularView.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import DesignSystem
import Foundation
import SwiftUI

struct AccessoryCircularView: View {
    let entry: Provider.Entry

    var body: some View {
        Gauge(value: Double(entry.procentsToNextLevel), in: 0...100) {
            Text("\(entry.procentsToNextLevel)%")
        } currentValueLabel: {
            Text(entry.level.image)
        }
        .gaugeStyle(.accessoryCircular)
    }
}
