//
//  NewsWidgetsBundle.swift
//  NewsWidgets
//
//  Created by Ярослав Куприянов on 05.04.2024.
//

import SwiftUI
import WidgetKit

@main
struct NewsWidgetsBundle: WidgetBundle {
    var body: some Widget {
        NewsWidgets()
        NewsWidgetsLiveActivity()
    }
}
