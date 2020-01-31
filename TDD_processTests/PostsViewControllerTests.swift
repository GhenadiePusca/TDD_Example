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
    
    private var completion: ((Result<Void, Error>) -> Void)?

    func load(completion: @escaping (Result<Void, Error>) -> Void) {
        loadCallCount += 1
        self.completion = completion
    }
    
    func completeLoadingWithSuccess() {
        completion?(.success(()))
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
        refreshControl?.beginRefreshing()
        refresh()
    }
    
    @objc func refresh() {
        postsLoader.load(completion: { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        })
    }
}

class PostsViewControllerTests: XCTestCase { 
    func test_loadRequestActions_requestsLoad() {
        let postsLoader = PostsLoader()

        let sut = PostsViewController(postsLoader: postsLoader)
        trackForMemoryLeaks(object: sut)
        XCTAssertEqual(postsLoader.loadCallCount, 0)

        sut.loadViewIfNeeded()
        XCTAssertEqual(postsLoader.loadCallCount, 1)

        sut.simulateReload()
        XCTAssertEqual(postsLoader.loadCallCount, 2)
    }
    
    func test_loadingActions_showsLoadingIndicator() {
        let postsLoader = PostsLoader()

        let sut = PostsViewController(postsLoader: postsLoader)
        trackForMemoryLeaks(object: sut)
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.isShowingLoadingSpinner, true)
        
        postsLoader.completeLoadingWithSuccess()
        XCTAssertEqual(sut.isShowingLoadingSpinner, false)
    }
}

extension XCTestCase {
    func trackForMemoryLeaks(object: AnyObject) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Expected sut to be deallocated")
        }
    }
}

extension PostsViewController { 
    var isShowingLoadingSpinner: Bool? {
        refreshControl?.isRefreshing
    }

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
