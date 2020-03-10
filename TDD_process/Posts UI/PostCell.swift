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
    public let retryButton = UIButton()

    func startAnimating() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    func stopAnimating() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
}
