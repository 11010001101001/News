//
//  SoundCard.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import SwiftUI
import DesignSystem
import ModelsKit

struct SoundCard: View {
    let viewModel: SettingsViewModel
    let soundTheme: SoundTheme

    @State private var isPlaying = false

    var body: some View {
        VerStack(alignment: .center, spacing: Constants.padding) {
            Image(systemName: isPlaying ? SFSymbols.speakerWave3Fill.rawValue : soundTheme.image.rawValue)
                .font(.title2)
            DesignedText(soundTheme.displayName)
                .font(.callout)
                .multilineTextAlignment(.center)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .markIsSelected(viewModel.soundTheme == soundTheme)
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.soundTheme == soundTheme
        ) {
            isPlaying = true
            viewModel.soundTheme = soundTheme
            viewModel.playRefresh(theme: soundTheme)
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                isPlaying = false
            }
        }
    }
}
