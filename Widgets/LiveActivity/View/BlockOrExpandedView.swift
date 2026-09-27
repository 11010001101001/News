//
//  BlockOrExpandedView.swift
//  News
//
//  Created by Slava on 24.09.2026.
//

import SwiftUI
import ModelsKit
import DesignSystem

struct BlockOrExpandedView: View {
    let procents: Int

    var body: some View {
        ZStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                LinearGradient(
                    colors: Level.allCases.map { $0.color },
                    startPoint: .leading, endPoint: .trailing
                )
                .mask(
                    ProgressView(value: Level.visualProgress(for: procents))
                        .progressViewStyle(.linear)
                )
            }
            .frame(height: 8)
            .padding(.horizontal, 29)

            levels
        }
        .padding(.horizontal, 20)
    }

    var levels: some View {
        let isNewbieActive = procents >= 0
        let isObserverActive = procents >= 25
        let isInsiderActive = procents >= 50
        let isNinjaActive = procents >= 75

        return HorStack {
            Circle()
                .fill(isNewbieActive ? Level.newbie.color : .gray)
                .frame(width: 30, height: 30)
                .shadow(color: isNewbieActive ? Level.newbie.color : .clear, radius: 7)
                .overlay(alignment: .center) {
                    Text(Level.newbie.image)
                        .grayscale(isNewbieActive ? 0 : 1)
                }

            Spacer()

            Circle()
                .fill(isObserverActive ? Level.observer.color : .gray)
                .frame(width: 30, height: 30)
                .shadow(
                    color: isObserverActive ? Level.observer.color : .clear, radius: 7
                )
                .overlay(alignment: .center) {
                    Text(Level.observer.image)
                        .grayscale(isObserverActive ? 0 : 1)
                }

            Spacer()

            Circle()
                .fill(isInsiderActive ? Level.insider.color : .gray)
                .frame(width: 30, height: 30)
                .shadow(color: isInsiderActive ? Level.insider.color : .clear, radius: 7)
                .overlay(alignment: .center) {
                    Text(Level.insider.image)
                        .grayscale(isInsiderActive ? 0 : 1)
                }

            Spacer()

            Circle()
                .fill(isNinjaActive ? Level.techNinja.color : .gray)
                .frame(width: 30, height: 30)
                .shadow(color: isNinjaActive ? Level.techNinja.color : .clear, radius: 7)
                .overlay(alignment: .center) {
                    Text(Level.techNinja.image)
                        .grayscale(isNinjaActive ? 0 : 1)
                }
        }
    }
}
