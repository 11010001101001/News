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
    let sound: SoundTheme

    @State private var isPlaying = false

    var body: some View {
        VerStack(alignment: .center, spacing: Constants.padding) {
            Image(systemName: isPlaying ? SFSymbols.speakerWave3Fill.rawValue : sound.image.rawValue)
                .font(.title2)
            DesignedText(sound.displayName)
                .font(.callout)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .markIsSelected(viewModel.soundTheme == sound.rawValue)
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.soundTheme == sound.rawValue
        ) {
            isPlaying = true
            viewModel.applySettings(sound.rawValue.lowercased())
            viewModel.playRefresh(theme: sound)
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                isPlaying = false
            }
        }
    }
}
