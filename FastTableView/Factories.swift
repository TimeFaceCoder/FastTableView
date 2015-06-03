//
//  Factories.swift
//  Layers
//
//  Created by René Cacheaux on 10/11/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    class func attributedStringForNickName(text :String) -> NSAttributedString {
        let nickNameAttributes =
        [NSFontAttributeName: UIFont.boldSystemFontOfSize(16),
            NSForegroundColorAttributeName: UIColor(red: 61/255, green: 176/255, blue: 232/255, alpha: 1),
            NSBackgroundColorAttributeName: UIColor.clearColor(),
            NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
        return NSAttributedString(string: text, attributes: nickNameAttributes)
    }
    
    class func attributedStringForTitleText(text: String) -> NSAttributedString {
        let titleAttributes =
        [NSFontAttributeName: UIFont.boldSystemFontOfSize(16),
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSBackgroundColorAttributeName: UIColor.clearColor(),
            NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
        return NSAttributedString(string: text, attributes: titleAttributes)
    }
    
    class func attributedStringForContentText(text: String) -> NSAttributedString {
        let descriptionAttributes =
        [NSFontAttributeName:UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSBackgroundColorAttributeName: UIColor.clearColor(),
            NSParagraphStyleAttributeName: NSParagraphStyle.contentParagraphStyle()]
        return NSAttributedString(string: text, attributes: descriptionAttributes)
    }
}

extension NSParagraphStyle {
    class func justifiedParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Justified
        return paragraphStyle.copy() as! NSParagraphStyle
    }
    class func contentParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Justified
        paragraphStyle.lineSpacing = 6
        paragraphStyle.paragraphSpacing = 6
        return paragraphStyle.copy() as! NSParagraphStyle
    }
}

extension NSShadow {
    class func titleTextShadow() -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowBlurRadius = 3.0
        return shadow
    }
    
    class func descriptionTextShadow() -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(white: 0.0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 3.0
        return shadow
    }
}
