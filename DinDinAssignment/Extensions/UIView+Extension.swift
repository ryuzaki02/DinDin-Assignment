//
//  UIView+Extension.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import UIKit



extension UIView{
    @IBInspectable
    var cornerRadius: CGFloat{
        set{
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
        get{
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat{
        set{
            layer.borderWidth = newValue
        }
        get{
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor{
        set{
            layer.borderColor = newValue.cgColor
        }
        get{
            if #available(iOS 13.0, *) {
                return UIColor(cgColor: layer.borderColor ?? CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.0))
            } else {
                // Fallback on earlier versions
                return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
            }
        }
    }
    
}

extension UIView{    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
    }
    
    // Show Progress Indicator
    func showProgressIndicator(){
        isUserInteractionEnabled = false
        // Create and add the view to the screen.
        let progressIndicator = ProgressIndicator(text: "Loading...")
        progressIndicator.tag = ProgressIndicatorTag
        addSubview(progressIndicator)
    }

    // Hide progress Indicator
    func hideProgressIndicator(){
        isUserInteractionEnabled = true        
        if let viewWithTag = viewWithTag(ProgressIndicatorTag) {
            viewWithTag.removeFromSuperview()
        }
    }
}
