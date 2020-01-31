//
//  MemoryLeaksTracking.swift
//  TDD_processTests
//
//  Created by Pusca, Ghenadie on 1/31/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(object: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Expected sut to be deallocated", file: file, line: line)
        }
    }
}
