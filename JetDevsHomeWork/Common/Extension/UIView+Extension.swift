//
//  UIView+Extension.swift
//  JetDevsHomeWork
//
//  Created by Sanam on 14/12/22.
//

import Foundation
import UIKit

extension UIView {
    
    @discardableResult func borderWidth(_ width: CGFloat) -> Self {
        layer.borderWidth = width
        layer.masksToBounds = true
        
        return self
    }
    
    @discardableResult func cornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        return self
    }
    
    @discardableResult func borderColor(_ color: UIColor = .black) -> Self {
        layer.borderColor = color.cgColor
        return self
    }
}
