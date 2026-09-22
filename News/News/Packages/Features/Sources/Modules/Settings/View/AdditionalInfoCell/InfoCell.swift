//
//  InfoCell.swift
//  News
//
//  Created by Ярослав Куприянов on 02.04.2024.
//

import SwiftUI
import DesignSystem

struct InfoCell: View {
    let id: LocalizedStringResource

    var body: some View {
        HorStack(spacing: Constants.padding) {
            Image(systemName: SFSymbols.infoCircleFill.rawValue)
                .padding(.leading, Constants.padding)
            DesignedText(text: id)
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .leading)
            Spacer()
        }
        .glassCard()
        .frame(height: 70)
    }
}
