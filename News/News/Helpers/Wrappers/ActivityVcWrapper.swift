//
//  ActivityVcWrapper.swift
//  News
//
//  Created by Ярослав Куприянов on 03.04.2024.
//

import Foundation
import UIKit
import SwiftUI

struct ContentWrapper: Identifiable {
    let id = UUID()
    let link: String
    let description: String
}

struct ActivityViewController: UIViewControllerRepresentable {
    let contentWrapper: ContentWrapper

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: [contentWrapper.link, contentWrapper.description],
            applicationActivities: nil)
        activityVC.completionWithItemsHandler = { _, _, _, _ in
            activityVC.dismiss(animated: true)
        }
        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
