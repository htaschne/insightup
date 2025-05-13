//
//  +UIColor.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import UIKit

// TODO(Agatha): we can remove this once Color Assets are setted up
extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove "#" if present
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        // Hex string should be 6 or 8 characters
        guard hexString.count == 6 || hexString.count == 8 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red, green, blue, alpha: CGFloat
        
        if hexString.count == 6 {
            red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8)  / 255.0
            blue  = CGFloat(rgbValue & 0x0000FF)         / 255.0
            alpha = 1.0
        } else {
            red   = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((rgbValue & 0x0000FF00) >> 8)  / 255.0
            alpha = CGFloat(rgbValue & 0x000000FF)         / 255.0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
