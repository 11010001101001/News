//
//  Loader.swift
//  News
//
//  Created by Ярослав Куприянов on 31.03.2024.
//

import Lottie
import SwiftUI

public struct Loader: View {
    let loaderName: String
    let shadowColor: Color

    public init(loaderName: String, shadowColor: Color) {
        self.loaderName = loaderName
        self.shadowColor = shadowColor
    }

    public var body: some View {
        LottieView(animation: .named(loaderName, bundle: .designSystem))
            .playing(loopMode: .loop)
            .id(loaderName)
            .scaleEffect(0.30)
            .gloss(color: shadowColor, numberOfLayers: 1)
    }
}
