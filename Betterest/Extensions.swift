//
//  Extensions.swift
//  Bestest
//
//  Created by Umar Qattan on 9/9/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    
    static let DidFinishPickingPhotos = Notification.Name(rawValue: "DidFinishPickingPhotos")
    
}

extension UIViewController {
    @objc func navigateHome(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: false)
    }
}

