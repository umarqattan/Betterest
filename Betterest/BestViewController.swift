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
    var flag: Bool = false
    
    // MARK: - PageRank Graph Properties
    var graph = Graph(isDirected: true)
    var vertices = [UIImage: Vertex]()
    
    
    // MARK: - Private Properties
    private var leftScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        return scrollView
    }()
    
    private var rightScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.flashScrollIndicators()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        return scrollView
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.register(BetterestCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.BETTEREST_CELL_ITEM)
        
        return collectionView
    }()
  
    // MARK: Setup
    fileprivate func setupViews() {
        self.view.addSubview(self.collectionView)
    }
    
    fileprivate func applyConstraints() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    fileprivate func applyStyles() {
        
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(navigateHome(_:))
        )
        
        self.photoPairs = generatePhotoPairs(photos: photos)
        
        self.view.backgroundColor = .white
        self.navigationItem.title = NavigationTitles.BEST

        self.leftScrollView.delegate = self
        self.rightScrollView.delegate = self
        
        self.setupViews()
        self.applyConstraints()
        self.applyStyles()
        self.initializePhotos()
    }
    
//    // MARK: Transitions
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        coordinator.animate(alongsideTransition: { _ in
//            let deltaTransform = coordinator.targetTransform
//            let deltaAngle: CGFloat = atan2(deltaTransform.b, deltaTransform.a)
//            var currentRotation = self.collectionView.layer.value(forKeyPath: "transform.rotation.z") as! CGFloat
//
//            currentRotation += -1 * deltaAngle + 0.0001
//            self.collectionView.layer.setValue(currentRotation, forKeyPath: "transform.rotation.z")
//            self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0))?.transform = CGAffineTransform(rotationAngle: -currentRotation)
//            self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0))?.transform = CGAffineTransform(rotationAngle: -currentRotation)
//            }, completion: { _ in
//
//            var currentTransform: CGAffineTransform = self.collectionView.transform
//            currentTransform.a = round(currentTransform.a)
//            currentTransform.b = round(currentTransform.b)
//            currentTransform.c = round(currentTransform.c)
//            currentTransform.d = round(currentTransform.d)
//            self.collectionView.transform = currentTransform
//        })
//        UIView.setAnimationsEnabled(false)
//        super.viewWillTransition(to: size, with: coordinator)
//    }
    
    
    // MARK: Initialize Photos
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
    
    fileprivate func initializePhotos() {
        guard self.photos.count > 1 else {
            assertionFailure("There must be more than one photo to compare.")
            return
        }
        
        self.photos.forEach({self.vertices[$0] = self.graph.addVertex(key: $0)})
        self.photoPairs = self.generatePhotoPairs(photos: self.photos)
    }
    
    func navigateToBetterestVC() {
        let bestestVC = BestestViewController()
        bestestVC.images = self.graph.pageRank(iterations: 20)
        self.navigationController?.pushViewController(bestestVC, animated: true)
    }
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension BestViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.BETTEREST_CELL_ITEM, for: indexPath) as! BetterestCollectionViewCell
        
        if let (leftPhoto, rightPhoto) = self.photoPairs.first {
            if indexPath.item == 0 {
                cell.configure(image: leftPhoto)
            } else {
                cell.configure(image: rightPhoto)
            }
        }
        return cell
    }
    
    func getImagesFromCells() -> (UIImage, UIImage)? {
        guard let leftItem = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? BetterestCollectionViewCell,
            let rightItem = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? BetterestCollectionViewCell,
            let leftImage = leftItem.getImage(),
            let rightImage = rightItem.getImage() else { return nil }
        return (leftImage, rightImage)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (newLeftPhoto, newRightPhoto) = self.photoPairs.removeFirst()
        
        if let currentPhotos = self.getImagesFromCells() {
            if indexPath.item == 0 {
                self.graph.addEdge(
                    source: self.vertices[currentPhotos.0]!,
                    sink: self.vertices[currentPhotos.1]!,
                    weight: 1)
            } else {
                self.graph.addEdge(
                    source: self.vertices[currentPhotos.1]!,
                    sink: self.vertices[currentPhotos.0]!,
                    weight: 1
                )
            }
        }
    
        if let photos = self.photoPairs.first {
            let leftCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! BetterestCollectionViewCell
            let rightCell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! BetterestCollectionViewCell
            leftCell.configure(image: newLeftPhoto)
            rightCell.configure(image: newRightPhoto)
            leftCell.resetZoom()
            rightCell.resetZoom()
            collectionView.reloadData()
        } else {
            navigateToBetterestVC()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = CGFloat(0)
        var height = CGFloat(0)
        if UIScreen.main.orientation.isPortrait {
            let newLayout = collectionViewLayout as! UICollectionViewFlowLayout
            newLayout.scrollDirection = .vertical
            width = collectionView.bounds.size.width
            height = (collectionView.bounds.size.height - 64) / 2.0
        } else {
            let newLayout = collectionViewLayout as! UICollectionViewFlowLayout
            newLayout.scrollDirection = .horizontal
            width = collectionView.bounds.size.width / 2.0
            height = collectionView.bounds.size.height
        }
        return CGSize(width: width, height: height)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        switch UIScreen.main.orientation {
        case .landscapeLeft:
            self.flag = true
            self.swapCells(
                from: IndexPath(item: 0, section: 0),
                to: IndexPath(item: 1, section: 0)
            )
        case .landscapeRight:
            break // noop
        case .portrait:
            if self.flag {
                self.swapCells(
                    from: IndexPath(item: 1, section: 0),
                    to: IndexPath(item: 0, section: 0)
                )
                self.flag = false
            }
        default:
            break
        }
        
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let newLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        newLayout.scrollDirection = (newLayout.scrollDirection == .horizontal) ? .vertical : .horizontal

        super.willTransition(to: newCollection, with: coordinator)
        UIView.setAnimationsEnabled(false)
    }
    
    func swapCells(from: IndexPath, to: IndexPath) {
        guard let fromItem = self.collectionView.cellForItem(at: from) as? BetterestCollectionViewCell,
            let toItem = self.collectionView.cellForItem(at: to) as? BetterestCollectionViewCell,
            let fromImage = fromItem.getImage(),
            let toImage = toItem.getImage() else { return }

            fromItem.configure(image: toImage)
            toItem.configure(image: fromImage)
    }
}






