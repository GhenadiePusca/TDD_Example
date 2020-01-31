//
//  UIControll+EventSimulation.swift
//  TDD_processTests
//
//  Created by Pusca, Ghenadie on 1/31/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import UIKit

extension UIControl {
    func simulateValueChange() {
        simulateEvent(event: .valueChanged)
    }

    func simulateEvent(event: Event) {
        allTargets.forEach { target in
            actions(forTarget: target,
                    forControlEvent: event)?.forEach {
                        (target as NSObject).perform(Selector($0))
            }
        }
    }
}
