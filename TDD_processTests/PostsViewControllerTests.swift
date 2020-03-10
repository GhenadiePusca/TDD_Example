//
//  PostsViewControllerTests.swift
//  TDD_processTests
//
//  Created by Pusca, Ghenadie on 1/31/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import Foundation
import XCTest
import TDD_process

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

class PostsViewControllerTests: XCTestCase { 
    func test_loadRequestActions_requestsLoad() {
        let (sut, postsLoader) = makeSut()
        XCTAssertEqual(postsLoader.loadCallCount, 0)

        sut.loadViewIfNeeded()
        XCTAssertEqual(postsLoader.loadCallCount, 1)

        sut.simulateReload()
        XCTAssertEqual(postsLoader.loadCallCount, 2)
    }
    
    func test_loadingActions_showsLoadingIndicator() {
        let (sut, postsLoader) = makeSut()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.isShowingLoadingSpinner, true)
        
        postsLoader.completeLoadingWithSuccess(at: 0)
        XCTAssertEqual(sut.isShowingLoadingSpinner, false)

        sut.simulateReload()
        XCTAssertEqual(sut.isShowingLoadingSpinner, true)

        postsLoader.completeLoadingWithError(at: 1)
        XCTAssertEqual(sut.isShowingLoadingSpinner, false)
    }

    func test_loadCompleted_rendersLoadedPosts() {
        let post = makePost(description: "Post 1 description")
        let post2 = makePost(description: "Post 2 description")

        let (sut, postsLoader) = makeSut()
        sut.loadViewIfNeeded()

        assertThat(sut, renders: [])

        postsLoader.completeLoadingWithSuccess(with: [post, post2])
        assertThat(sut, renders: [post, post2])

        sut.simulateReload()
        postsLoader.completeLoadingWithError(at: 1)
        assertThat(sut, renders: [post, post2])
    }

    func test_imageLoading_startsImageLoadingWhenPostIsVisible() {
        let post = makePost(description: "Post 1 description")
        let post2 = makePost(description: "Post 2 description")

        let (sut, postsLoader) = makeSut()
        sut.loadViewIfNeeded()
        postsLoader.completeLoadingWithSuccess(with: [post, post2])

        XCTAssertEqual(postsLoader.imageRequests, [])

        sut.simulatePostVisible(at: 0)
        XCTAssertEqual(postsLoader.imageRequests, [post.image])

        sut.simulatePostVisible(at: 1)
        XCTAssertEqual(postsLoader.imageRequests, [post.image, post2.image])
    }

    func test_imageLoading_cancellsImageLoadingWhenPostIsNoMoreVisible() {
        let post = makePost(description: "Post 1 description")
        let post2 = makePost(description: "Post 2 description")

        let (sut, postsLoader) = makeSut()
        sut.loadViewIfNeeded()
        postsLoader.completeLoadingWithSuccess(with: [post, post2])

        XCTAssertEqual(postsLoader.imageRequests, [])

        sut.simulatePostVisible(at: 0)
        sut.simulatePostVisible(at: 1)
        XCTAssertEqual(postsLoader.imageRequests, [post.image, post2.image])

        sut.simulatePostNoMoreVisible(at: 0)
        XCTAssertEqual(postsLoader.cancelledImageRequests, [post.image])

        sut.simulatePostNoMoreVisible(at: 1)
        XCTAssertEqual(postsLoader.cancelledImageRequests, [post.image, post2.image])
    }

    func test_imageLoading_showsImageLoadingIndicatorWhenPostIsVisible() {
        let post = makePost(description: "Post 1 description")
        let post2 = makePost(description: "Post 2 description")

        let (sut, postsLoader) = makeSut()
        sut.loadViewIfNeeded()
        postsLoader.completeLoadingWithSuccess(with: [post, post2])

        XCTAssertEqual(postsLoader.imageRequests, [])

        let view0 = sut.simulatePostVisible(at: 0)
        XCTAssertEqual(view0?.showsImageLoadingIndicator, true)

        let view1 = sut.simulatePostVisible(at: 1)
        XCTAssertEqual(view1?.showsImageLoadingIndicator, true)
    }

    // MARK: - Helper methods

    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (PostsViewController, PostsLoaderMock) {
        let postsLoader = PostsLoaderMock()
        let sut = PostsViewController(postsLoader: postsLoader, imageDataLoader: postsLoader)
        trackForMemoryLeaks(object: sut, file: file, line: line)
        
        return (sut, postsLoader)
    }

    private func assertThat(_ sut: PostsViewController,
                            renders posts: [Post],
                            file: StaticString = #file,
                            line: UInt = #line) {
        guard sut.numberOfRenderedPosts == posts.count else {
            return XCTFail("Expected to render \(posts.count) posts, instead did render \(sut.numberOfRenderedPosts) posts",
                file: file,
                line: line)
        }

        posts.enumerated().forEach { index, post in
            assertThat(sut,
                       renders: post,
                       at: index,
                       file: file,
                       line: line)
        }
    }

    private func assertThat(_ sut: PostsViewController,
                            renders post: Post,
                            at index: Int,
                            file: StaticString = #file,
                            line: UInt = #line) {
        let postView = sut.postView(at: index) as? PostCell
        XCTAssertNotNil(postView, file: file, line: line)
        XCTAssertEqual(postView?.descriptionText, post.description, file: file, line: line)
    }

    func makePost(image: URL = URL(string: "https://any.com")!,
                  description: String) -> Post {
        Post(image: image, description: description)
    }

    private class PostsLoaderMock: PostsLoader, ImageDataLoader {
        var loadCallCount: Int {
            completions.count
        }

        private var completions = [LoadCompletion]()

        func load(completion: @escaping LoadCompletion) {
            completions.append(completion)
        }

        func completeLoadingWithSuccess(at idx: Int = 0, with posts: [Post] = []) {
            completions[idx](.success(posts))
        }

        func completeLoadingWithError(at idx: Int = 0) {
            completions[idx](.failure(anyError()))
        }

        // MARK: - Image data loading
        var imageRequests = [URL]()
        var cancelledImageRequests = [URL]()

        private struct MockLoadingTask: LoadingTask {
            let onCancell: () -> Void

            func cancel() {
                onCancell()
            }
        }

        func loadImageData(for url: URL) -> LoadingTask {
            imageRequests.append(url)

            return MockLoadingTask { [weak self] in
                self?.cancelledImageRequests.append(url)
            }
        }
    }
}

extension PostCell {
    var descriptionText: String? {
        descriptionLabel.text
    }

    var showsImageLoadingIndicator: Bool {
        !loadingIndicator.isHidden && loadingIndicator.isAnimating
    }
}
extension PostsViewController {
    private var postsSection: Int { 0 }

    var isShowingLoadingSpinner: Bool? {
        refreshControl?.isRefreshing
    }

    func simulateReload() {
        refreshControl?.simulateValueChange()
    }

    var numberOfRenderedPosts: Int {
        tableView.numberOfRows(inSection: postsSection)
    }

    @discardableResult
    func simulatePostVisible(at idx: Int) -> PostCell? {
        postView(at: idx) as? PostCell
    }

    func simulatePostNoMoreVisible(at idx: Int) {
        let cell = simulatePostVisible(at: idx)!
        let indexPath = IndexPath(row: idx, section: postsSection)
        tableView.delegate?.tableView?(tableView,
                                       didEndDisplaying: cell,
                                       forRowAt: indexPath)
    }

    func postView(at idx: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: idx, section: postsSection)
        return tableView.dataSource?.tableView(tableView,
                                               cellForRowAt: indexPath)
    }
}
