//
//  ActivityVcWrapper.swift
//  News
//
//  Created by Ярослав Куприянов on 03.04.2024.
//

import Foundation
import SwiftUI
import UIKit

public struct ContentWrapper: Identifiable {
    public let id = UUID()
    let link: String
    let description: String

    public init(link: String, description: String) {
        self.link = link
        self.description = description
    }
}

public struct ActivityViewController: UIViewControllerRepresentable {
    public let contentWrapper: ContentWrapper

    public init(contentWrapper: ContentWrapper) {
        self.contentWrapper = contentWrapper
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: [contentWrapper.link, contentWrapper.description],
            applicationActivities: nil)
        activityVC.completionWithItemsHandler = { _, _, _, _ in
            activityVC.dismiss(animated: true)
        }
        return activityVC
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
