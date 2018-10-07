//
//  ShareViewController.swift
//  BetterestExtension
//
//  Created by Umar Qattan on 10/3/2018
//  Copyright © 2018 ukaton. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {
    
    let sharedKey = Keys.sharedKey
    
    var selectedImages: [UIImage] = []
    var imagesData: [Data] = []
    
    var numberOfRotations = 0
    
    private lazy var selectedPhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(ShareImageCollectionCell.self, forCellWithReuseIdentifier: Identifiers.SelectedPhotosCollectionView.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.setupViews()
        self.applyConstraints()
    
        self.navigationItem.title = Identifiers.ShareViewController.navigationTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(nextAction(_:)))
    }
    
    func setupViews() {
        self.view.addSubview(self.selectedPhotosCollectionView)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
                self.selectedPhotosCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.selectedPhotosCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.selectedPhotosCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.selectedPhotosCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    @objc func nextAction(_ sender: Any) {
        self.redirectToHostApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectedPhotosCollectionView.delegate = self
        self.selectedPhotosCollectionView.dataSource = self
        
        self.manageImages()
    }
    
    @objc func cancelAction(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func redirectToHostApp() {
        let url = URL(string: "Betterest://dataUrl=\(sharedKey)")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func manageImages() {
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as String
        
        for (index, attachment) in (content.attachments as! [NSItemProvider]).enumerated() {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { [weak self] data, error in
                    
                    if error == nil, let url = data as? URL, let this = self {
                        do {
                            
                            // GETTING RAW DATA
                            let rawData = try Data(contentsOf: url)
                            let rawImage = UIImage(data: rawData)
                            
                            // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
                            // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
                            
                            let image = UIImage.scaleImage(image: rawImage!, maxDimension: 500)
                            let imgData = image.pngData()
                            
                            this.selectedImages.append(image)
                            this.imagesData.append(imgData!)
                            
                            if index == (content.attachments?.count)! - 1 {
                                DispatchQueue.main.async {
                                    this.selectedPhotosCollectionView.reloadData()
                                    let userDefaults = UserDefaults(suiteName: Keys.suiteName)
                                    userDefaults?.set(this.imagesData, forKey: this.sharedKey)
                                    userDefaults?.synchronize()
                                }
                            }
                        }
                        catch let exp {
                            print("GETTING EXCEPTION \(exp.localizedDescription)")
                        }
                        
                    } else {
                        print("GETTING ERROR")
                        let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return Styler.SelectedPhotosCollectionView.cellSize(collectionView.frame)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.SelectedPhotosCollectionView.cellIdentifier, for: indexPath) as! ShareImageCollectionCell
        cell.configure(image: selectedImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIImage {
    class func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage ?? image
    }
}
