//
//  Date+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 09.04.2024.
//

import Foundation

extension Date {
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_En")
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }

    func makeTestDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_En")
        return dateFormatter.string(from: self)
    }
}
