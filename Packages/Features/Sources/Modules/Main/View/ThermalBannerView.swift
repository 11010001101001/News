//
//  ThermalBannerView.swift
//  Features
//
//  Created by Slava on 09.10.2026.
//

import DesignSystem
import LocalizationKit
import SwiftUI

struct ThermalBannerView: View {
    var body: some View {
        HorStack(spacing: 10) {
            Image(systemName: SFSymbols.thermometerSunFill.rawValue)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.orange)

            DesignedText(Strings.expertOverheated)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            Spacer()
        }
        .padding(.horizontal, Constants.padding)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color.orange.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(Color.orange.opacity(0.25), lineWidth: 1)
                )
        )
        .glassClearInteractive()
        .padding(.horizontal, Constants.padding)
    }
}
