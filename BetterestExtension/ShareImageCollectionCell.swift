//
//  ShareImageCollectionCell.swift
//  BetterestExtension
//
//  Created by Umar Qattan on 10/5/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import UIKit

class ShareImageCollectionCell: UICollectionViewCell {
	
    private var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
        self.applyConstraints()
        self.applyStyles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	func configure(image: UIImage) {
        self.imageView.image = image
	}

    fileprivate func setupViews() {
        self.contentView.addSubview(self.imageView)
    }
    
    fileprivate func applyConstraints() {
        NSLayoutConstraint.activate([
            // imageView constraints
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    fileprivate func applyStyles() {
        self.contentView.layer.borderColor = Styler.SelectedPhotosCollectionView.borderColor
    }
}
