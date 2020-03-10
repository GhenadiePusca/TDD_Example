//
//  Post.swift
//  TDD_process
//
//  Created by Pusca, Ghenadie on 3/10/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import Foundation

public struct Post {
    public let image: URL
    public let description: String

    public init(image: URL, description: String) {
        self.image = image
        self.description = description
    }
}
