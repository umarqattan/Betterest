//
//  BestViewController.swift
//  Bestest
//
//  Created by Umar Qattan on 9/12/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class BestViewController: UIViewController {
    
    // MARK: - SLComposeService Properties
    fileprivate var sharedIdentifier = Identifiers.SHARED
    
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
    
    private var remainingPhotosLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private var leftContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        return view
    }()
    
    private var rightContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        return view
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
    
    private var horizontalPhotoStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(.allButUpsideDown)
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
        self.view.addSubview(self.leftContainerView)
        self.view.addSubview(self.rightContainerView)
        
        self.leftContainerView.addSubview(self.leftBestPhoto)
        self.rightContainerView.addSubview(self.rightBestPhoto)
        
        self.horizontalPhotoStackView.addArrangedSubview(self.leftContainerView)
        self.horizontalPhotoStackView.addArrangedSubview(self.rightContainerView)
        self.view.addSubview(self.horizontalPhotoStackView)
    }
    
    fileprivate func applyConstraints() {
        NSLayoutConstraint.activate([
            // mainTitle constraints
            self.mainTitle.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.mainTitle.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.mainTitle.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.mainTitle.heightAnchor.constraint(equalToConstant: 35),
            
//            // leftContainerView constraints
//            self.leftContainerView.heightAnchor.constraint(equalToConstant: self.view.frame.size.width / 3.0),
//            self.leftContainerView.widthAnchor.constraint(equalTo: self.leftContainerView.heightAnchor, multiplier: 1.0),
//
//            // rightContainerView constraints
//            self.rightContainerView.heightAnchor.constraint(equalToConstant: self.view.frame.size.width / 3.0),
//            self.rightContainerView.widthAnchor.constraint(equalTo: self.rightContainerView.heightAnchor, multiplier: 1.0),
            
            // leftBestPhoto constraints
            self.leftBestPhoto.leadingAnchor.constraint(equalTo: self.leftContainerView.leadingAnchor),
            self.leftBestPhoto.bottomAnchor.constraint(equalTo: self.leftContainerView.bottomAnchor),
            self.leftBestPhoto.trailingAnchor.constraint(equalTo: self.leftContainerView.trailingAnchor),
            self.leftBestPhoto.topAnchor.constraint(equalTo: self.leftContainerView.topAnchor),

            // rightBestPhoto constraints
            self.rightBestPhoto.leadingAnchor.constraint(equalTo: self.rightContainerView.leadingAnchor),
            self.rightBestPhoto.bottomAnchor.constraint(equalTo: self.rightContainerView.bottomAnchor),
            self.rightBestPhoto.trailingAnchor.constraint(equalTo: self.rightContainerView.trailingAnchor),
            self.rightBestPhoto.topAnchor.constraint(equalTo: self.rightContainerView.topAnchor),
            
            // horizontalPhotoStackView constraints
            self.horizontalPhotoStackView.topAnchor.constraint(equalTo: self.mainTitle.bottomAnchor),
            self.horizontalPhotoStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.horizontalPhotoStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.horizontalPhotoStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    fileprivate func applyStyles() {
        // mainTitle style
        self.mainTitle.text = Titles.BETTEREST
    
        // left and right containerView styles
        self.leftContainerView.layer.cornerRadius = 5
        self.rightContainerView.layer.cornerRadius = 5
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
                //self.finalAnimationOnTop(better: self.leftContainerView, worse: self.rightContainerView)
            }
        default:
            let (leftPhoto, rightPhoto) = self.photoPairs.removeFirst()
            self.graph.addEdge(source: self.vertices[leftPhoto]!, sink: self.vertices[rightPhoto]!, weight: 1)
            
            if let photos = self.photoPairs.first {
                
                self.leftBestPhoto.image = photos.0
                self.rightBestPhoto.image = photos.1
                
                //self.animatePhotosOnTap(better: self.leftContainerView, worse: self.rightContainerView, photos: photos)
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
            
            //self.finalAnimationOnTop(better: self.rightContainerView, worse: self.leftContainerView)
        default:
            let (leftPhoto, rightPhoto) = self.photoPairs.removeFirst()
            self.graph.addEdge(source: self.vertices[rightPhoto]!, sink: self.vertices[leftPhoto]!, weight: 1)
            
            if let photos = self.photoPairs.first {
                
                self.leftBestPhoto.image = photos.0
                self.rightBestPhoto.image = photos.1
                
                //self.animatePhotosOnTap(better: rightContainerView, worse: leftContainerView, photos: photos)
            }
        }
    }
    
    func animatePhotosOnTap(better: UIView, worse: UIView, photos: (UIImage, UIImage)) {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
        
        // worseView layer borderWidth animation
        let worseLayerBorderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        worseLayerBorderWidthAnimation.fromValue = CGFloat(0.5)
        worseLayerBorderWidthAnimation.toValue = CGFloat(3.0)
        worse.layer.borderWidth = CGFloat(3.0)
        worse.layer.add(worseLayerBorderWidthAnimation, forKey: "worse borderWidth")
        
        // worseView layer borderColor animation
        let worseLayerBorderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        worseLayerBorderColorAnimation.fromValue = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        worseLayerBorderColorAnimation.toValue = UIColor.red.cgColor
        worse.layer.borderColor = UIColor.red.cgColor
        worse.layer.add(worseLayerBorderColorAnimation, forKey: "worse borderColor")
        
        // betterView layer borderWidth animation
        let betterLayerBorderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        betterLayerBorderWidthAnimation.fromValue = CGFloat(0.5)
        betterLayerBorderWidthAnimation.toValue = CGFloat(3.0)
        better.layer.borderWidth = CGFloat(3.0)
        better.layer.add(betterLayerBorderWidthAnimation, forKey: "better borderWidth")
        
        // betterView layer borderColor animation
        let betterLayerBorderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        betterLayerBorderColorAnimation.fromValue = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        betterLayerBorderColorAnimation.toValue = UIColor.green.cgColor
        better.layer.borderColor = UIColor.green.cgColor
        better.layer.add(betterLayerBorderColorAnimation, forKey: "better borderColor")
        
        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseOut, animations: {
            self.horizontalPhotoStackView.center.y += self.view.frame.size.height
            
        }, completion: { (Bool) in
            
            self.leftBestPhoto.image = photos.0
            self.rightBestPhoto.image = photos.1
            self.horizontalPhotoStackView.center.y -= 2 * self.view.frame.size.height
            worse.layer.borderWidth = 0.5
            worse.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
            better.layer.borderWidth = 0.5
            better.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 1.0, options: .curveEaseInOut, animations: {
            self.horizontalPhotoStackView.center.y += self.view.frame.size.height

        }, completion: nil)
        
        CATransaction.commit()
        
    }
    
    func finalAnimationOnTop(better: UIView, worse: UIView) {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
        
        // worseView layer borderWidth animation
        let worseLayerBorderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        worseLayerBorderWidthAnimation.fromValue = CGFloat(0.5)
        worseLayerBorderWidthAnimation.toValue = CGFloat(3.0)
        worse.layer.borderWidth = CGFloat(3.0)
        worse.layer.add(worseLayerBorderWidthAnimation, forKey: "worse borderWidth")
        
        // worseView layer borderColor animation
        let worseLayerBorderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        worseLayerBorderColorAnimation.fromValue = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        worseLayerBorderColorAnimation.toValue = UIColor.red.cgColor
        worse.layer.borderColor = UIColor.red.cgColor
        worse.layer.add(worseLayerBorderColorAnimation, forKey: "worse borderColor")
        
        // betterView layer borderWidth animation
        let betterLayerBorderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        betterLayerBorderWidthAnimation.fromValue = CGFloat(0.5)
        betterLayerBorderWidthAnimation.toValue = CGFloat(3.0)
        better.layer.borderWidth = CGFloat(3.0)
        better.layer.add(betterLayerBorderWidthAnimation, forKey: "better borderWidth")
        
        // betterView layer borderColor animation
        let betterLayerBorderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        betterLayerBorderColorAnimation.fromValue = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        betterLayerBorderColorAnimation.toValue = UIColor.green.cgColor
        better.layer.borderColor = UIColor.green.cgColor
        better.layer.add(betterLayerBorderColorAnimation, forKey: "better borderColor")
        
        // animate the photoStackView to fade into the top left
        UIView.animate(withDuration: 0.4, delay: 0.6, options: .curveEaseOut, animations: {
            self.horizontalPhotoStackView.alpha = 0.0
            self.horizontalPhotoStackView.center.y += self.view.frame.size.height
        }, completion: { (Bool) in
            let bestestVC = BestestViewController()
            bestestVC.images = self.graph.pageRank(iterations: 20)
            self.navigationController?.pushViewController(bestestVC, animated: true)
        })
        
        CATransaction.commit()
    }
    
    func navigateToBetterestVC() {
        let bestestVC = BestestViewController()
        bestestVC.images = self.graph.pageRank(iterations: 20)
        self.navigationController?.pushViewController(bestestVC, animated: true)
    }
}
