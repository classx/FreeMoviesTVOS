//
//  FreeMoviesMain.swift
//  FreeMoviesTV
//
//  Created by Peter Morris on 07/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import UIKit
import PDMovieKit_tvOS

class FreeMoviesMain {
    let window: UIWindow
    init(window: UIWindow = UIWindow()) {
        self.window = window
    }
    func start() {
        window.rootViewController = LoadingViewController()
        window.makeKeyAndVisible()
        loadLibrary()
    }
    func loadLibrary() {
        PDLibrary.library(session: URLSession.shared, completionQueue: OperationQueue.main) { library, error in
            if let library = library {
                let featured = ContentShelf.init(title: "Featured", items: library.featured)
                let mostPopular = ContentShelf.init(title: "Most popular", items: library.mostWatched)
                let categories = ContentShelf.init(title: "All categories", items: library.categories)
                let recentlyAdded = ContentShelf.init(title: "Recently added", items: library.recentlyAdded)
                let topRated = ContentShelf.init(title: "Top rated", items: library.topRated)
                let shelves = ContentShelves.init(content: [featured, mostPopular, categories, recentlyAdded, topRated])
                self.showLibrary(shelves)
            } else {
                
            }
        }
    }
    func showLibrary(_ shelves: ContentShelves) {
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = FeaturedViewController(content: shelves)
        })
    }
}
