//
//  CGFloat+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation
import UIKit

@MainActor
public extension CGFloat {
    private static var currentWindowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first
    }

    static var screenHeight: CGFloat {
        currentWindowScene?.screen.bounds.height ?? .zero
    }

    static var screenWidth: CGFloat {
        currentWindowScene?.screen.bounds.width ?? .zero
    }

    static let sideInsets: CGFloat = 32.0
}
