//
//  HomeViewController.swift
//  Bestest
//
//  Created by Umar Qattan on 9/9/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos

class HomeViewController: UIViewController {

    // MARK: - Private properties
    private var selectPhotosButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(
            Buttons.SELECT_PHOTOS,
            for: UIControl.State.normal
        )
        button.setTitleColor(
            UIColor.blue,
            for: UIControl.State.normal
        )
        button.addTarget(
            self,
            action: #selector(selectPhotos(_:)),
            for: UIControl.Event.touchUpInside
        )
        
        return button
    }()

    // OpalImagePickerViewController
    private var imagePicker: OpalImagePickerController?
    
    private var viewHasAppeared = false
    private var viewHadAppeared = false
    // MARK: - View Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = nil
        
        if !self.viewHasAppeared {
            self.viewHasAppeared = true
            self.imagePicker = OpalImagePickerController()
            self.imagePicker?.imagePickerDelegate = self
            self.addObservers()
            self.selectPhotos()
        } else {
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.viewHadAppeared {
            self.viewHadAppeared = true
            return
        } else {
            self.imagePicker = OpalImagePickerController()
            self.imagePicker?.imagePickerDelegate = self
            self.addObservers()
            self.selectPhotos()
        }
    }
}

// MARK: - ViewController setup extension
extension HomeViewController {
    
    // MARK: - Private methods
    fileprivate func setupViews() {
        self.view.addSubview(self.selectPhotosButton)
    }
    
    fileprivate func applyConstraints() {
        NSLayoutConstraint.activate([
            // selectPhotosButton constraints
            self.selectPhotosButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.selectPhotosButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    fileprivate func applyStyles() {
        self.view.backgroundColor = .white
        self.navigationItem.title = NavigationTitles.HOME
    }

    fileprivate func setupImagePicker() {
        guard let imagePicker = self.imagePicker else {
            assertionFailure("OpalImagePickerController cannot be nil.")
            return
        }
        imagePicker.imagePickerDelegate = self
    }
    
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentBestestViewController(_:)), name: Notification.Name.DidFinishPickingPhotos, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.DidFinishPickingPhotos, object: nil)
    }
    
    @objc func presentBestestViewController(_ notification: Notification) {
        guard let _ = self.imagePicker else {
            assertionFailure("OpalImagePickerController cannot be nil.")
            return
        }
        
        let bestVC = BestViewController()
        
        if let userInfo = notification.userInfo,
            let images = userInfo[NotificationKeys.IMAGES] as? [UIImage] {
            bestVC.photos = images
        }
        
        if let _ = self.imagePicker {
            UIView.animate(withDuration: 0, delay: 1.0, options: .curveEaseOut, animations: {
                self.imagePicker?.dismiss(animated: false, completion: nil)
            }, completion: nil)
            
            self.imagePicker = nil
            self.imagePicker?.imagePickerDelegate = nil
            self.removeObservers()
        }
        
        self.navigationController?.pushViewController(bestVC, animated: false)
    }
    
    @objc func selectPhotos(_ sender: UIButton) {
        guard let imagePicker = self.imagePicker else {
            assertionFailure("OpalImagePickerController cannot be nil.")
            return
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func selectPhotos() {
        guard let imagePicker = self.imagePicker else {
            assertionFailure("OpalImagePickerController cannot be nil.")
            return
        }
        self.present(imagePicker, animated: false, completion: nil)
    }
}

// MARK: - HomeViewController OpalImagePickerControllerDelegate methods
extension HomeViewController: OpalImagePickerControllerDelegate {
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        NotificationCenter.default.post(
            name: NSNotification.Name.DidFinishPickingPhotos,
            object: nil,
            userInfo: [NotificationKeys.IMAGES: images]
        )
    }
}
