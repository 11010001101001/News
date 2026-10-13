//
//  EmptyFavoritesView.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import DesignSystem
import LocalizationKit
import ModelsKit
import SwiftUI

struct FavoritesEmptyView: View {
    @Environment(\.dismiss) private var dismiss

    let viewModel: FavoritesViewModel

    @State private var motion: CGPoint = .zero

    var body: some View {
        HorStack {
            Spacer()
            VerStack(alignment: .center) {
                Group {
                    titleView
                    image
                    reloadButton
                }
                .padding(Constants.padding)
            }
            .glassClearInteractive()
            Spacer()
        }
    }
}

// MARK: - Content
extension FavoritesEmptyView {
    fileprivate var titleView: some View {
        DesignedText(Strings.favoritesEmpty)
            .labelStyle(.titleOnly)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .font(.headline)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, CGFloat.sideInsets)
    }

    fileprivate var image: some View {
        Images.favoritesEmptyCat
            .resizable()
            .frame(width: 170, height: 170)
            .scaledToFill()
            .padding(.horizontal)
            .rotation3DEffect(.degrees(motion.x * 45), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(motion.y * 45), axis: (x: 1, y: 0, z: 0))
            .onAppear {
                viewModel.startMotion { motion in
                    self.motion = motion
                }
            }
            .onDisappear {
                viewModel.stopMotion()
            }
    }

    fileprivate var reloadButton: some View {
        CustomButton(
            action: { dismiss() },
            title: Strings.favoritesAdd
        )
    }
}
