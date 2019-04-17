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
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 1280 / 3, height: 720 / 3)
        layout.headerReferenceSize = CGSize(width: 1280, height: 60.0)
        layout.minimumLineSpacing = 20.0
        layout.sectionInset.top = 20.0
        layout.sectionInset.bottom = 20.0
        collectionView.collectionViewLayout = layout
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
        cell.titleLabel.enablesMarqueeWhenAncestorFocused = true
//        content.itemImage(at: indexPath.row, onShelf: indexPath.section, completion: { (data) in
//            if let data = data, let image = UIImage(data: data) {
//                cell.imageView.image = image
//                //cell.imageView.contentMode = .scaleAspectFill
//                //cell.imageView.clipsToBounds = true
//                UIView.transition(with: cell.imageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
//                    cell.imageView.isHidden = false
//                })
//            }
//        })
    }
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return IndexPath(item: 0, section: 0)
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
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
        print("HEader Section: \(indexPath.section) and Row: \(indexPath.row)")
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath
        )
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Cell Section: \(indexPath.section) and Row: \(indexPath.row)")
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}

extension FeaturedViewController: UICollectionViewDelegateFlowLayout {
}
