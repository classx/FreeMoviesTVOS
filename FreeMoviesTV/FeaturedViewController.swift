//
//  FeaturedViewController.swift
//  FreeMoviesTV
//
//  Created by Peter Morris on 07/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    let content: ContentShelves
    init(content: ContentShelves) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        self.content = ContentShelves()
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "header"
        )
    }
}

extension FeaturedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        guard let view = view as? HeaderCollectionReusableView else { return }
        view.titleLabel.text = content.shelfTitle(index: indexPath.section)
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ItemCollectionViewCell else { return }
        cell.titleLabel.text = content.itemTitle(at: indexPath.row, onShelf: indexPath.section)
    }
}

extension FeaturedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return content.numberOfShelves()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.numberOfItemsOnShelf(index: section)
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: "header",
            withReuseIdentifier: "header",
            for: indexPath
        )
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}

extension FeaturedViewController: UICollectionViewDelegateFlowLayout {
}
