//
//  BestViewController.swift
//  Bestest
//
//  Created by Umar Qattan on 9/12/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import UIKit

class BestViewController: UIViewController {
    
    // MARK: - Photos Properties
    var photos = [UIImage]()
    var photoPairs = [(UIImage, UIImage)]()
    
    // MARK: - PageRank Graph Properties
    var graph = Graph(isDirected: true)
    var vertices = [UIImage: Vertex]()

    private var mainTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private var leftBestPhoto: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
    
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private var rightBestPhoto: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private var photoStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(navigateHome(_:))
        )
        
        self.photoPairs = generatePhotoPairs(photos: photos)
        
        if self.photoPairs.count >= 1,
            let (leftPhoto, rightPhoto) = self.photoPairs.first {
            self.leftBestPhoto.image = leftPhoto
            self.rightBestPhoto.image = rightPhoto
        }
        
        self.view.backgroundColor = .white
        self.navigationItem.title = NavigationTitles.BEST
        
        self.leftBestPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftBestPhotoTapped(_:))))
        self.rightBestPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightBestPhotoTapped(_:))))
        
        self.setupViews()
        self.applyConstraints()
        self.applyStyles()
        self.initializePhotos()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if UIScreen.main.orientation == .portrait {
            self.photoStackView.axis = .vertical
            self.photoStackView.removeArrangedSubview(self.leftBestPhoto)
            self.photoStackView.removeArrangedSubview(self.rightBestPhoto)
            self.photoStackView.addArrangedSubview(self.leftBestPhoto)
            self.photoStackView.addArrangedSubview(self.rightBestPhoto)
        } else if UIScreen.main.orientation == .landscapeRight {
            self.photoStackView.axis = .horizontal
            self.photoStackView.removeArrangedSubview(self.leftBestPhoto)
            self.photoStackView.removeArrangedSubview(self.rightBestPhoto)
            self.photoStackView.addArrangedSubview(self.leftBestPhoto)
            self.photoStackView.addArrangedSubview(self.rightBestPhoto)
        } else if UIScreen.main.orientation == .landscapeLeft {
            self.photoStackView.axis = .horizontal
            self.photoStackView.removeArrangedSubview(self.leftBestPhoto)
            self.photoStackView.removeArrangedSubview(self.rightBestPhoto)
            self.photoStackView.addArrangedSubview(self.rightBestPhoto)
            self.photoStackView.addArrangedSubview(self.leftBestPhoto)
        }
    }
}

extension BestViewController {
    fileprivate func generatePhotoPairs(photos: [UIImage]) -> [(UIImage, UIImage)] {
        var photoPairs = [(UIImage, UIImage)]()
        for x in 0...photos.count-1 {
            for y in (x+1)..<photos.count {
                photoPairs.append((photos[x], photos[y]))
            }
        }
        
        photoPairs = photoPairs.shuffled()
        
        return photoPairs
    }
}

extension BestViewController {
    
    fileprivate func setupViews() {
        self.view.addSubview(self.mainTitle)
        self.view.addSubview(self.photoStackView)
        self.photoStackView.addArrangedSubview(self.leftBestPhoto)
        self.photoStackView.addArrangedSubview(self.rightBestPhoto)
    }
    
    fileprivate func applyConstraints() {
        NSLayoutConstraint.activate([
            // mainTitle constraints
            self.mainTitle.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.mainTitle.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.mainTitle.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.mainTitle.heightAnchor.constraint(equalToConstant: 35),
            
            // photoStackView constraints
            self.photoStackView.topAnchor.constraint(equalTo: self.mainTitle.bottomAnchor),
            self.photoStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.photoStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.photoStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            // leftBestPhoto constraints
            self.leftBestPhoto.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 10) / 2.0),
            self.leftBestPhoto.heightAnchor.constraint(equalTo: self.leftBestPhoto.widthAnchor, multiplier: 1.0),
            
            // rightBestPhoto constraints
            self.rightBestPhoto.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 10) / 2.0),
            self.rightBestPhoto.heightAnchor.constraint(equalTo: self.rightBestPhoto.widthAnchor, multiplier: 1.0)
        ])
    }
    
    fileprivate func applyStyles() {
        // mainTitle style
        self.mainTitle.text = Titles.BETTEREST
    }
    
    fileprivate func initializePhotos() {
        guard self.photos.count > 1 else {
            assertionFailure("There must be more than one photo to compare.")
            return
        }
        
        self.photos.forEach({self.vertices[$0] = self.graph.addVertex(key: $0)})
        self.photoPairs = self.generatePhotoPairs(photos: self.photos)
    
        if self.photoPairs.count > 0 {
            if let (leftPhoto, rightPhoto) = self.photoPairs.first {
                self.leftBestPhoto.image = leftPhoto
                self.rightBestPhoto.image = rightPhoto
            }
        }
    }
    
    @objc func leftBestPhotoTapped(_ recognizer: UITapGestureRecognizer) {
        
        switch self.photoPairs.count {
        case 0:
            return
        case 1:
            let (leftPhoto, rightPhoto) = self.photoPairs.removeFirst()
            self.graph.addEdge(source: self.vertices[leftPhoto]!, sink: self.vertices[rightPhoto]!, weight: 1)
            
            if let (leftPhoto, rightPhoto) = self.photoPairs.first {
                self.leftBestPhoto.image = leftPhoto
                self.rightBestPhoto.image = rightPhoto
            } else {
                navigateToBetterestVC()
            }
        default:
            let (leftPhoto, rightPhoto) = self.photoPairs.removeFirst()
            self.graph.addEdge(source: self.vertices[leftPhoto]!, sink: self.vertices[rightPhoto]!, weight: 1)
            if let photos = self.photoPairs.first {
                self.leftBestPhoto.image = photos.0
                self.rightBestPhoto.image = photos.1
            }
        }
    }
    
    @objc func rightBestPhotoTapped(_ recognizer: UITapGestureRecognizer) {
        switch self.photoPairs.count {
        case 0:
            return
        case 1:
            let (leftPhoto, rightPhoto) = self.photoPairs.removeFirst()
            self.graph.addEdge(source: self.vertices[rightPhoto]!, sink: self.vertices[leftPhoto]!, weight: 1)
            navigateToBetterestVC()
        default:
            let (leftPhoto, rightPhoto) = self.photoPairs.removeFirst()
            self.graph.addEdge(source: self.vertices[rightPhoto]!, sink: self.vertices[leftPhoto]!, weight: 1)
            if let photos = self.photoPairs.first {
                self.leftBestPhoto.image = photos.0
                self.rightBestPhoto.image = photos.1
            }
        }
    }
    
    func navigateToBetterestVC() {
        let bestestVC = BestestViewController()
        bestestVC.images = self.graph.pageRank(iterations: 20)
        self.navigationController?.pushViewController(bestestVC, animated: true)
    }
}
