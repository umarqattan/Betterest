//
//  Animations.swift
//  Betterest
//
//  Created by Umar Qattan on 10/7/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import Foundation
import UIKit

final class Animations {
    
// revisit later on 
//    static func animatePhotosOnTap(better: UIView, worse: UIView, photos: (UIImage, UIImage)) {
//
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(0.4)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
//
//        // worseView layer borderWidth animation
//        let worseLayerBorderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
//        worseLayerBorderWidthAnimation.fromValue = CGFloat(0.5)
//        worseLayerBorderWidthAnimation.toValue = CGFloat(3.0)
//        worse.layer.borderWidth = CGFloat(3.0)
//        worse.layer.add(worseLayerBorderWidthAnimation, forKey: "worse borderWidth")
//
//        // worseView layer borderColor animation
//        let worseLayerBorderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
//        worseLayerBorderColorAnimation.fromValue = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
//        worseLayerBorderColorAnimation.toValue = UIColor.red.cgColor
//        worse.layer.borderColor = UIColor.red.cgColor
//        worse.layer.add(worseLayerBorderColorAnimation, forKey: "worse borderColor")
//
//        // betterView layer borderWidth animation
//        let betterLayerBorderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
//        betterLayerBorderWidthAnimation.fromValue = CGFloat(0.5)
//        betterLayerBorderWidthAnimation.toValue = CGFloat(3.0)
//        better.layer.borderWidth = CGFloat(3.0)
//        better.layer.add(betterLayerBorderWidthAnimation, forKey: "better borderWidth")
//
//        // betterView layer borderColor animation
//        let betterLayerBorderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
//        betterLayerBorderColorAnimation.fromValue = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
//        betterLayerBorderColorAnimation.toValue = UIColor.green.cgColor
//        better.layer.borderColor = UIColor.green.cgColor
//        better.layer.add(betterLayerBorderColorAnimation, forKey: "better borderColor")
//
//        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseOut, animations: {
//            self.photoStackView.center.y += self.view.frame.size.height
//
//        }, completion: { (Bool) in
//
//            self.leftBestPhoto.image = photos.0
//            self.rightBestPhoto.image = photos.1
//            self.photoStackView.center.y -= 2 * self.view.frame.size.height
//            worse.layer.borderWidth = 0.5
//            worse.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
//            better.layer.borderWidth = 0.5
//            better.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
//
//        })
//
//        UIView.animate(withDuration: 0.4, delay: 1.0, options: .curveEaseInOut, animations: {
//            self.photoStackView.center.y += self.view.frame.size.height
//
//        }, completion: nil)
//
//        CATransaction.commit()
//    }
//
//    static func finalAnimationOnTop(better: UIView, worse: UIView) {
//
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(0.4)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
//
//        // worseView layer borderWidth animation
//        let worseLayerBorderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
//        worseLayerBorderWidthAnimation.fromValue = CGFloat(0.5)
//        worseLayerBorderWidthAnimation.toValue = CGFloat(3.0)
//        worse.layer.borderWidth = CGFloat(3.0)
//        worse.layer.add(worseLayerBorderWidthAnimation, forKey: "worse borderWidth")
//
//        // worseView layer borderColor animation
//        let worseLayerBorderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
//        worseLayerBorderColorAnimation.fromValue = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
//        worseLayerBorderColorAnimation.toValue = UIColor.red.cgColor
//        worse.layer.borderColor = UIColor.red.cgColor
//        worse.layer.add(worseLayerBorderColorAnimation, forKey: "worse borderColor")
//
//        // betterView layer borderWidth animation
//        let betterLayerBorderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
//        betterLayerBorderWidthAnimation.fromValue = CGFloat(0.5)
//        betterLayerBorderWidthAnimation.toValue = CGFloat(3.0)
//        better.layer.borderWidth = CGFloat(3.0)
//        better.layer.add(betterLayerBorderWidthAnimation, forKey: "better borderWidth")
//
//        // betterView layer borderColor animation
//        let betterLayerBorderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
//        betterLayerBorderColorAnimation.fromValue = UIColor(red: 151/255.0, green: 151/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
//        betterLayerBorderColorAnimation.toValue = UIColor.green.cgColor
//        better.layer.borderColor = UIColor.green.cgColor
//        better.layer.add(betterLayerBorderColorAnimation, forKey: "better borderColor")
//
//        // animate the photoStackView to fade into the top left
//        UIView.animate(withDuration: 0.4, delay: 0.6, options: .curveEaseOut, animations: {
//            self.photoStackView.alpha = 0.0
//            self.photoStackView.center.y += self.view.frame.size.height
//        }, completion: { (Bool) in
//            let bestestVC = BestestViewController()
//            bestestVC.images = self.graph.pageRank(iterations: 20)
//            self.navigationController?.pushViewController(bestestVC, animated: true)
//        })
//
//        CATransaction.commit()
//    }
    
}
