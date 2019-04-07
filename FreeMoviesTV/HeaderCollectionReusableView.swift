//
//  HeaderCollectionReusableView.swift
//  FreeMoviesTV
//
//  Created by Peter Morris on 07/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    func sharedInit() {
        backgroundColor = UIColor.yellow
        layoutTitleLabel()
    }
    func layoutTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
