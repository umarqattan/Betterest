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
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.photoStackView.axis = UIScreen.main.orientation.isLandscape ? .horizontal : .vertical
    }
    
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { _ in
            let deltaTransform = coordinator.targetTransform
            let deltaAngle: CGFloat = atan2(deltaTransform.b, deltaTransform.a)
            var currentRotation = self.photoStackView.layer.value(forKeyPath: "transform.rotation.z") as! CGFloat

            currentRotation += -1 * deltaAngle + 0.0001
            self.photoStackView.layer.setValue(currentRotation, forKeyPath: "transform.rotation.z")
            self.leftBestPhoto.transform = CGAffineTransform(rotationAngle: -currentRotation)
            self.rightBestPhoto.transform = CGAffineTransform(rotationAngle: -currentRotation)
            
        }, completion: { _ in
            
            var currentTransform: CGAffineTransform = self.photoStackView.transform
            currentTransform.a = round(currentTransform.a)
            currentTransform.b = round(currentTransform.b)
            currentTransform.c = round(currentTransform.c)
            currentTransform.d = round(currentTransform.d)
            self.photoStackView.transform = currentTransform
            
        })
        UIView.setAnimationsEnabled(false)
        
        super.viewWillTransition(to: size, with: coordinator)
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
        self.view.addSubview(self.photoStackView)
        self.photoStackView.addArrangedSubview(self.leftBestPhoto)
        self.photoStackView.addArrangedSubview(self.rightBestPhoto)
    }
    
    fileprivate func applyConstraints() {
        NSLayoutConstraint.activate([

            self.photoStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.photoStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            self.leftBestPhoto.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            self.rightBestPhoto.widthAnchor.constraint(equalTo: self.leftBestPhoto.widthAnchor),
            self.leftBestPhoto.heightAnchor.constraint(equalTo: self.leftBestPhoto.widthAnchor),
            self.rightBestPhoto.heightAnchor.constraint(equalTo: self.leftBestPhoto.heightAnchor),
        ])
    }
    
    fileprivate func applyStyles() {
        
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
