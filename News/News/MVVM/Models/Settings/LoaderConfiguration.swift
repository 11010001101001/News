//
//  LoaderConfiguration.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import Foundation
import SwiftUI

enum LoaderConfiguration: String, CaseIterable, Identifiable {
	var id: Self { return self }

	static var title: String { "Loader" }

	case rocket
	case hourGlass = "hourglass"
	case astronaut
	case hamster
	case cat

	var shadowColor: Color {
		switch self {
		case .rocket: .orange
		case .hourGlass: .cyan
		case .astronaut: .red
		case .hamster: .blue
		case .cat: .indigo
		}
	}
}
