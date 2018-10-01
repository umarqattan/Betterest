//
//  PhotoTableViewCell.swift
//  Bestest
//
//  Created by Umar Qattan on 9/14/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    // MARK: - private properties
    
    // -> containerView
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    // -> photoImageView
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // footerContainerView
    // -> horizontalStackView
    //      -> photoLabel [left]
    //      -> favoriteButton [right]
    //////////////////////////////////
    private lazy var footerHorizontalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private lazy var photoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "heart_outline.png")
        
        return imageView
    }()
    
//    private lazy var favoriteButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isUserInteractionEnabled = true
//        button.setImage(UIImage(named: "heart_outline.png"), for: .normal)
//        button.backgroundColor = .white
//
//        return button
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.isUserInteractionEnabled = true
        
        self.setupViews()
        self.applyConstraints()
        self.applyStyles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoTableViewCell {
    
    fileprivate func setupViews() {
       // self.favoriteButton.addTarget(self, action: #selector(onFavoriteButtonTapped), for: .touchUpInside)
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.photoImageView)
        self.containerView.addSubview(self.footerHorizontalStackView)
        self.footerHorizontalStackView.addArrangedSubview(self.photoLabel)
        self.footerHorizontalStackView.addArrangedSubview(self.favoriteImageView)
    }
    
    fileprivate func applyConstraints() {
        NSLayoutConstraint.activate([
                // containerView constraints
                self.containerView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                self.containerView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                self.containerView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                self.containerView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),

                // photoImageView constraints
                self.photoImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
                self.photoImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
                self.photoImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
                
                // footerHorizontalStackView constraints
                self.footerHorizontalStackView.leadingAnchor.constraint(equalTo: self.containerView.layoutMarginsGuide.leadingAnchor),
                self.footerHorizontalStackView.topAnchor.constraint(equalTo: self.photoImageView.bottomAnchor),
                self.footerHorizontalStackView.trailingAnchor.constraint(equalTo: self.containerView.layoutMarginsGuide.trailingAnchor),
                self.footerHorizontalStackView.bottomAnchor.constraint(equalTo: self.containerView.layoutMarginsGuide.bottomAnchor),
                
                // favoriteButton constraints
                self.favoriteImageView.widthAnchor.constraint(equalToConstant: 40.0),
                self.favoriteImageView.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    @objc func onFavoriteButtonTapped() {
//        if let stateImage = self.favoriteButton.image(for: .normal) {
//            let setImage = (stateImage == UIImage(named: "heart_outline.png")!) ? UIImage(named: "heart_filled.png") : UIImage(named: "heart_outline.png")
//            self.favoriteButton.setImage(setImage, for: .normal)
//        }
    }
    
    @objc func isFavorite() -> Bool {
        
        if let stateImage = self.favoriteImageView.image, let favoriteImage = UIImage(named: "heart_filled.png") {
            return stateImage == favoriteImage
        } else {
            return false
        }
        
//        if let stateImage = self.favoriteButton.image(for: .normal), let favoriteImage = UIImage(named: "heart_filled.png")  {
//            return stateImage == favoriteImage
//        } else {
//            return false
//        }
    }
    
    func favorite() {
        self.favoriteImageView.image = UIImage(named: "heart_filled.png")
        //self.favoriteButton.setImage(UIImage(named: "heart_filled.png"), for: .normal)
    }
    
    func unfavorite() {
        self.favoriteImageView.image = UIImage(named: "heart_outline.png")
        //self.favoriteButton.setImage(UIImage(named: "heart_outline.png"), for: .normal)
    }
    
    func getImage() -> UIImage? {
        return self.photoImageView.image
    }

    fileprivate func applyStyles() {
        self.selectionStyle = .none
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = .clear
    
        // for the upper UIImageView rounded corners
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 5

        // for the cell's drop shadow
        self.layer.masksToBounds = false
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        
    }
    
    
    
    func configure(image: UIImage, rank:Int) {
        self.photoImageView.image = image
        self.photoLabel.text = "#\(rank+1)"
    }
}

extension UIImage {
    class func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
