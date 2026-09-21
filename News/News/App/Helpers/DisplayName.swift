//
//  DisplayName.swift
//  News
//
//  Created by Slava on 21.09.2026.
//

import Foundation

protocol DisplayName {
    var displayName: LocalizedStringResource { get }
    var rawValue: String { get }
}
