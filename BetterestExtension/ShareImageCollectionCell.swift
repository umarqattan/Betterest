//
//  ShareImageCollectionCell.swift
//  ImagePicker
//
//  Created by Abhishek on 19/09/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class ShareImageCollectionCell: UICollectionViewCell {
	
	@IBOutlet weak var imageView: UIImageView!
	
	func configure(image: UIImage) {
        //self.imageView.layer.cornerRadius = 10
        //self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
		self.imageView.image = image
	}
}
