//
//  CombineTimer.swift
//  News
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import Combine

final class CombineTimer: ObservableObject {
    @Published var isFired = false

    private var timer: AnyCancellable?

    func start(delay: TimeInterval) {
        timer?.cancel()
        timer = Just(())
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] in
                self?.isFired = true
            })
    }

    func stop() {
        timer?.cancel()
        timer = nil
        isFired = false
    }
}
