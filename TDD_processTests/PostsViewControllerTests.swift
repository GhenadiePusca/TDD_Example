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
    
    func load() {
        loadCallCount += 1
    }
}

class PostsViewController: UITableViewController {
    private let postsLoader: PostsLoader

    init(postsLoader: PostsLoader) {
        self.postsLoader = postsLoader  
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refresh()
    }
    
    @objc func refresh() {
        postsLoader.load()
    }
}

class PostsViewControllerTests: XCTestCase { 
    func test_init_doesNotRequestLoad() {
        let postsLoader = PostsLoader()
        let _ = PostsViewController(postsLoader: postsLoader)
        
        XCTAssertEqual(postsLoader.loadCallCount, 0)
    }
    
    func test_viewLoaded_requestPostsLoad() {
        let postsLoader = PostsLoader()
        let sut = PostsViewController(postsLoader: postsLoader)
        
        sut.loadViewIfNeeded()

        XCTAssertEqual(postsLoader.loadCallCount, 1)
    }
    
    func test_onReload_requestPostsLoad() {
        let postsLoader = PostsLoader()
        let sut = PostsViewController(postsLoader: postsLoader)
        
        sut.loadViewIfNeeded()
        sut.simulateReload()
        XCTAssertEqual(postsLoader.loadCallCount, 2)
    }
}

extension PostsViewController { 
    func simulateReload() {
        refreshControl?.simulateValueChange()
    }
}

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
