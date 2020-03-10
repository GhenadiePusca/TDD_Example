//
//  PostCell.swift
//  TDD_process
//
//  Created by Pusca, Ghenadie on 3/10/20.
//  Copyright © 2020 Pusca, Ghenadie. All rights reserved.
//

import UIKit

public class PostCell: UITableViewCell {
    public let descriptionLabel = UILabel()
    public let loadingIndicator = UIActivityIndicatorView()
    public lazy var retryButton = makeRetryButton()
    public let postImageView = UIImageView()

    var onRetryTapped: () -> Void = { }

    func startAnimating() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    func stopAnimating() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }

    private func makeRetryButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return button
    }

    @objc func retryTapped() {
        onRetryTapped()
    }
}
