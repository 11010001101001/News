//
//  OnTap.swift
//  News
//
//  Created by Ярослав Куприянов on 08.07.2024.
//

import SwiftUI

public struct OnTap: ViewModifier {
    @State private var scale: CGFloat = 1.0

    private let execute: (() -> Void)?
    private let completion: (() -> Void)?

    public init(
        execute: (() -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) {
        self.execute = execute
        self.completion = completion
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .contentShape(.rect)
            .onTapGesture {
                execute?()
                withAnimation(.easeInOut(duration: .leastNonzeroMagnitude)) {
                    scale = 0.98
                } completion: {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        scale = 1.0
                    } completion: {
                        completion?()
                    }
                }
            }
    }
}
