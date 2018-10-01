//
//  ShareViewController.swift
//  ImageShare
//
//  Created by Abhishek on 19/09/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {
    
    let sharedKey = "ImageSharePhotoKey"
    
    var selectedImages: [UIImage] = []
    var imagesData: [Data] = []
    
    @IBOutlet weak var imgCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self
        
        self.navigationItem.title = "Picked Images"
        self.manageImages()
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        let layout = UICollectionViewFlowLayout()
        var width = CGFloat()
        
        if newCollection.horizontalSizeClass == .regular {
            layout.scrollDirection = .horizontal
            width = imgCollectionView.frame.size.width / 3

        } else {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            width = imgCollectionView.frame.size.width - 10
        }
        
        layout.itemSize = CGSize(width: width, height: width)
        self.imgCollectionView.collectionViewLayout = layout
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()
        var width = CGFloat()
        
        if self.traitCollection.horizontalSizeClass == .regular {
            layout.scrollDirection = .horizontal
            width = imgCollectionView.frame.size.width / 3
            
        } else {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            width = imgCollectionView.frame.size.width - 10
        }
        
        layout.itemSize = CGSize(width: width, height: width)
        self.imgCollectionView.collectionViewLayout = layout
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        self.redirectToHostApp()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
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
                            
                            let image = UIImage.resizeImage(image: rawImage!, width: 500, height: 500)
                            let imgData = image.pngData()
                            
                            this.selectedImages.append(image)
                            this.imagesData.append(imgData!)
                            
                            if index == (content.attachments?.count)! - 1 {
                                DispatchQueue.main.async {
                                    this.imgCollectionView.reloadData()
                                    let userDefaults = UserDefaults(suiteName: "group.ukaton.Betterest")
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
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if self.traitCollection.horizontalSizeClass == .regular {
//            collectionViewLayout.la
//            return CGSize(width: (imgCollectionView.frame.size.width)/6, height: (imgCollectionView.frame.size.width)/6)
//        } else {
//            return CGSize(width: (imgCollectionView.frame.size.width)/2/2, height: (imgCollectionView.frame.size.width)/2.2)
//        }
//
//    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if self.traitCollection.horizontalSizeClass == .regular {
            return UIEdgeInsets(top: self.view.layoutMargins.top, left: 0, bottom: self.view.layoutMargins.bottom, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: self.view.layoutMargins.left, bottom: 0, right: self.view.layoutMargins.right)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareImageCollectionCell", for: indexPath) as! ShareImageCollectionCell
        cell.configure(image: selectedImages[indexPath.row])
        return cell
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
