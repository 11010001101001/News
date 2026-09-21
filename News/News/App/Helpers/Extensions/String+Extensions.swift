//
//  String+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

extension String {
    static let empty = ""
    static let spacer = " "
    static let dash = " / "

    func toReadableDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_En")

        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM d, h:mm a"

        return dateFormatter.string(from: date!)
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
