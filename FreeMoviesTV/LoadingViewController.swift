//
//  LoadingViewController.swift
//  FreeMoviesTV
//
//  Created by Peter Morris on 07/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    override func loadView() {
        super.loadView()
        layoutActivityIndicator()
    }
    func layoutActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
}
