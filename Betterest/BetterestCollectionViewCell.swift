//
//  BetterestCollectionViewCell.swift
//  Betterest
//
//  Created by Umar Qattan on 10/20/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import UIKit

class BetterestCollectionViewCell: UICollectionViewCell {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isUserInteractionEnabled = false
        scrollView.flashScrollIndicators()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        return scrollView
    }()
    
    private var containerView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        return containerView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
        self.applyConstraints()
        
        self.scrollView.delegate = self
    }

    func resetZoom() {
        self.scrollView.zoomScale = 1.0
    }
    
    func configure(image: UIImage) {
        self.imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addGestureRecognizer(self.scrollView.panGestureRecognizer)
        self.contentView.addGestureRecognizer(self.scrollView.pinchGestureRecognizer!)
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.imageView)
    }
    
    private func applyConstraints() {
    
        NSLayoutConstraint.activate([
            // scrollView constraints
            self.scrollView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            
            self.containerView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            
//            // imageView constraints
            self.imageView.widthAnchor.constraint(equalToConstant: self.containerView.frame.width),
            self.imageView.heightAnchor.constraint(equalToConstant: self.containerView.frame.height),
            self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
        ])
    }
    
    func getImage() -> UIImage? {
        guard let image = self.imageView.image else { return nil }
        return image
    }
}

extension BetterestCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }
}
