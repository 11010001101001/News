//
//  AccessoryCircularView.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI

struct AccessoryCircularView: View {
    let entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.black.clipShape(.circle)
            VStack {
                Text(entry.category.prefix(4))
                    .fontDesign(.monospaced)
                    .font(.system(size: 11))
                    .padding(EdgeInsets(top: .zero,
                                        leading: 7,
                                        bottom: .zero,
                                        trailing: 7))
                    .lineLimit(1)

                Divider()
                    .frame(width: 40)

                Text(entry.date, style: .time)
                    .fontDesign(.monospaced)
                    .font(.system(size: 11))
                    .padding(EdgeInsets(top: -3,
                                        leading: 7,
                                        bottom: .zero,
                                        trailing: 7))
            }
        }
    }
}
