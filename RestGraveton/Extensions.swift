//
//  Extensions.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/29/24.
//

import Foundation
import UIKit

protocol inputDataDelegate: AnyObject {
    func getData(_ order: Order)
}

protocol SelectedDelegate: AnyObject {
    func selectedCell(_ index: Int)
}

extension UILabel {
    
    func setDifferentColor(string: String, location: Int, length: Int){
        
        let attText = NSMutableAttributedString(string: string)
        attText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSRange(location:location,length:length))
        attributedText = attText
    }
}

extension UIImageView {
    
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = tintedImage
        self.tintColor = color
    }
}
