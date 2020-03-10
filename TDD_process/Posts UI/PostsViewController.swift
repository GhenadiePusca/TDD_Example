//
//  PostsViewController.swift
//  TDD_process
//
//  Created by Pusca, Ghenadie on 3/10/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import UIKit

public class PostsViewController: UITableViewController {
    private let postsLoader: PostsLoader
    private let imageDataLoader: ImageDataLoader
    private var tableModel = [Post]()
    private var imageLoadingTasks = [LoadingTask]()

    public init(postsLoader: PostsLoader, imageDataLoader: ImageDataLoader) {
        self.postsLoader = postsLoader
        self.imageDataLoader = imageDataLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refresh()
    }

    @objc func refresh() {
        refreshControl?.beginRefreshing()
        postsLoader.load(completion: { [weak self] result in
            if let posts = try? result.get() {
                self?.tableModel = posts
            }
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        })
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableModel[indexPath.row]
        let cell = PostCell()
        cell.descriptionLabel.text = model.description
        cell.startAnimating()
        let task = imageDataLoader.loadImageData(for: model.image) { [weak cell] in
            cell?.stopAnimating()
        }
        imageLoadingTasks.append(task)

        return cell
    }

    public override func tableView(_ tableView: UITableView,
                                   didEndDisplaying cell: UITableViewCell,
                                   forRowAt indexPath: IndexPath) {
        imageLoadingTasks[indexPath.row].cancel()
    }
}
