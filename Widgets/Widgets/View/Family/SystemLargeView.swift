//
//  SmallView.swift
//  News
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI
import LocalizationKit
import DesignSystem

struct SystemLargeView: View {
    let entry: Provider.Entry

    @Environment(\.colorScheme) private var colorScheme

    private var color: Color {
        colorScheme == .dark ? Color.white.opacity(0.05) :  Color.black.opacity(0.05)
    }

    var body: some View {
        VStack(spacing: 12) {
            mediumView
                .padding(-12)
            progressLine
            lastViewedTitle
        }
        .padding(12)
    }

    var mediumView: some View {
        SystemMediumView(entry: entry)
            .frame(minWidth: 120, maxHeight: .infinity, alignment: .leading)
    }

    var progressLine: some View {
        VerStack(spacing: 6) {
            HorStack {
                Text(Strings.widgetsProgress)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(entry.procentsToNextLevel)" + "%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.level.color)
            }
            ProgressView(value: Float(entry.procentsToNextLevel) / 100)
                .tint(entry.level.color)
        }
        .padding(12)
        .background(color, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    var lastViewedTitle: some View {
        VerStack(spacing: 6) {
            Text(Strings.widgetsLatest)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(.secondary)

            Text(entry.lastViewedTitle)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
                .foregroundStyle(.primary)
                .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(color, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
