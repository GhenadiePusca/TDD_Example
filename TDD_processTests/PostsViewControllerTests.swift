//
//  PostsViewControllerTests.swift
//  TDD_processTests
//
//  Created by Pusca, Ghenadie on 1/31/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import Foundation
import XCTest

/*
    As a user I do want to see a list of the available posts.
 
    Posts {
      image
      description
    }

    Posts Use cases:
    - Posts are loaded as soon the screen is visible.
    - While posts are loading a loading indicator is shown.
    - If load failed, a error banner is shownß
    - User can manually reload the posts list.
 
   Post image use case:
    - Image is loaded once post visible.
    - While image is loading - a loading indicator is shown.
    - If image load failed, a retry button is shown.
    - On retry the image is loaded again.
 */

class PostsLoader {
    private(set) var loadCallCount = 0
}

class PostsViewController {
    private let postsLoader: PostsLoader

    init(postsLoader: PostsLoader) {
        self.postsLoader = postsLoader        
    }
}

class PostsViewControllerTests: XCTestCase { 
    func test_init_doesNotRequestLoad() {
        let postsLoader = PostsLoader()
        let sut = PostsViewController(postsLoader: postsLoader)
        
        XCTAssertEqual(postsLoader.loadCallCount, 0)
    }
}
