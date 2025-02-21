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

	static var rotationCoordinates: [(x: CGFloat, y: CGFloat, z: CGFloat)] {
		var randomNumbers = [CGFloat]()

		for num in stride(from: -1.0, to: 1.0, by: 0.1) {
			randomNumbers.append(num)
		}

		let randomX = randomNumbers.randomElement() ?? .zero
		let randomY = randomNumbers.randomElement() ?? .zero
		let randomZ = randomNumbers.randomElement() ?? .zero

		var coordinates = [(x: CGFloat, y: CGFloat, z: CGFloat)]()

		for _ in 0...10 {
			coordinates.append((x: randomX,
								y: randomY,
								z: randomZ))
		}

		return coordinates
	}

	static var randomCoordinates: (x: CGFloat, y: CGFloat, z: CGFloat) {
		rotationCoordinates.randomElement() ?? (x: 1.0, y: 1.0, z: 0.0)
	}
}
