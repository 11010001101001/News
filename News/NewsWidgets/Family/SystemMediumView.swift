//
//  SmallView.swift
//  News
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI

struct SystemMediumView: View {
    let entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                category
                Divider()
                    .frame(width: 300)
                level
            }
        }
    }

    var category: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("Category: ")
                .font(.system(size: 20, design: .monospaced))
                .foregroundStyle(.gray)
            Text(entry.category)
                .font(.system(size: 20, design: .monospaced))
                .foregroundStyle(.gray)
        }
    }

    var level: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("Your lvl: ")
                .font(.system(size: 20, design: .monospaced))
                .foregroundStyle(.gray)
            HStack(alignment: .bottom) {
                Text(entry.level.image + " " + entry.level.rawValue)
                    .font(.system(size: 20, design: .monospaced))
                    .foregroundStyle(.gray)
                    .shadow(color: entry.level.color, radius: 7)
            }
        }
    }
}
