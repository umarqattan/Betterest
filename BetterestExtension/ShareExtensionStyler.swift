//
//  ShareExtensionStyler.swift
//  BetterestExtension
//
//  Created by Umar Qattan on 10/5/18.
//  Copyright © 2018 ukaton. All rights reserved.
//


import Foundation
import UIKit

final class Styler {
    
    final class SelectedPhotosCollectionView {
        
        static let borderColor = UIColor.white.cgColor
        static let numberOfColumns = CGFloat(4)
        
        static func cellSize(_ frame: CGRect) -> CGSize {
            let width = frame.size.width
            let numberOfColumns = self.numberOfColumns
            let cellWidth = width / numberOfColumns
            let cellHeight = cellWidth
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
}
