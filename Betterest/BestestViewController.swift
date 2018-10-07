//
//  BestestViewController.swift
//  Bestest
//
//  Created by Umar Qattan on 9/9/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import UIKit
import Photos

class BestestViewController: UIViewController {

    // MARK: - Public properties
    var images = [UIImage]()
    //var favorites = [IndexPath]()
    var favorites = [IndexPath: Bool]()

    // MARK: - Private properties
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = false
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: Identifiers.BETTEREST_CELL)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(.allButUpsideDown)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(navigateHome(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        self.setupViews()
        self.applyConstraints()
        self.applyStyles()
        self.setupDelegates()
    }
}

extension BestestViewController {
    
    // MARK: - Private methods
    fileprivate func setupViews() {
        self.view.addSubview(self.tableView)
    }
    
    fileprivate func applyConstraints() {
        NSLayoutConstraint.activate([
            // tableView constraints
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    fileprivate func applyStyles() {
        self.navigationItem.title = NavigationTitles.BETTEREST
    }
    
    fileprivate func setupDelegates() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @objc func save() {
        var favorites = 0
        let library = PHPhotoLibrary.shared()
        
        for (indexPath, isFavorite) in self.favorites {
            if isFavorite {
                library.savePhoto(image: self.images[indexPath.section], albumName: "Betterest")
                favorites += 1
            }
        }
        
        var message = ""
        if favorites == 0 {
            message = "Favorite at least 1 Photo to save to your album."
            let alert = UIAlertController(title: AlertKeys.NO_FAVORITES, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: AlertKeys.DISMISS, style: .cancel , handler:{ (UIAlertAction)in
            }))
            self.present(alert, animated: false, completion: nil)
            return
        }
        
        if favorites == 1 {
            message = "\(favorites) photo has been added to your Betterest album"
        } else {
            message = "\(favorites) photos have been added to your Betterest album"
        }
        
        let alert = UIAlertController(title: AlertKeys.SAVED, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: AlertKeys.DISMISS, style: .cancel , handler:{ (UIAlertAction)in
            self.navigationController?.popToRootViewController(animated: false)
        }))
        
        self.present(alert, animated: false, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource protocol methods
extension BestestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.images.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.BETTEREST_CELL, for: indexPath) as! PhotoTableViewCell

        cell.unfavorite()
        cell.configure(image: self.images[indexPath.section], rank: indexPath.section)
        
        if let isFavorite = self.favorites[indexPath] {
            if isFavorite {
                cell.favorite()
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate protocol methods
extension BestestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PhotoTableViewCell
        
        if !cell.isFavorite() {
            cell.favorite()
            self.favorites[indexPath] = true
        } else {
            cell.unfavorite()
            self.favorites[indexPath] = false
        }
    }
}


