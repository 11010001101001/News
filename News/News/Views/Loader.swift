//
//  Loader.swift
//  News
//
//  Created by Ярослав Куприянов on 31.03.2024.
//

import SwiftUI
import Lottie
import Combine

struct Loader: View {
    let loaderName: String
    let shadowColor: Color

    var body: some View {
        LottieView(animation: .named(loaderName))
            .playing(loopMode: .loop)
            .scaleEffect(0.30)
			.gloss(color: shadowColor, numberOfLayers: 1)
    }
}
