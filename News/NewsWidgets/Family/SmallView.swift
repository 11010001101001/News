//
//  SmallView.swift
//  News
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI

struct SmallView: View {
    let entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                category
                Divider()
                    .frame(width: 100)
                level
            }
        }
    }

    var category: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("* Category *")
                .fontDesign(.monospaced)
                .font(.subheadline)
                .foregroundStyle(.gray)
            Text(entry.category)
                .fontDesign(.monospaced)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }

    var level: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("* Your lvl *")
                .fontDesign(.monospaced)
                .font(.subheadline)
                .foregroundStyle(.gray)
            HStack(alignment: .bottom) {
                Text(entry.level.image + " " + entry.level.rawValue)
                    .fontDesign(.monospaced)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .shadow(color: entry.level.color, radius: 7)
            }
        }
    }
}
