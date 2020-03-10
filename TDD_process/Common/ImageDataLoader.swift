//
//  ImageDataLoading.swift
//  TDD_process
//
//  Created by Pusca, Ghenadie on 3/10/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import Foundation

public protocol ImageDataLoader {
    func loadImageData(for url: URL)
}
