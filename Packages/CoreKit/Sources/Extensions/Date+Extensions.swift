//
//  Date+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 09.04.2024.
//

import Foundation

public extension Date {
    var hour: Date { self.addingTimeInterval(3600) }

    var time: String {
        self.formatted(date: .omitted, time: .shortened)
    }
}
