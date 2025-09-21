//
//  CGFloat+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation
import UIKit

extension CGFloat {
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    static let sideInsets: CGFloat = 32.0
}
