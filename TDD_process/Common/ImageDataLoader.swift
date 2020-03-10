//
//  ImageDataLoading.swift
//  TDD_process
//
//  Created by Pusca, Ghenadie on 3/10/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import Foundation

public protocol LoadingTask {
    func cancel()
}

public protocol ImageDataLoader {
    typealias LoadCompletion = () -> Void
    func loadImageData(for url: URL, completion: @escaping LoadCompletion) -> LoadingTask
}
