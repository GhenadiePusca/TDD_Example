//
//  Utils.swift
//  TDD_processTests
//
//  Created by Pusca, Ghenadie on 2/7/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import Foundation

func anyError() -> Error {
    NSError(domain: "Test", code: 1)
}

func anyData() -> Data {
    Data()
}
