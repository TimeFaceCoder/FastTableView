//
//  Factories.swift
//  FastTableView
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
    
    class func attributedStringForTimeFrom(text :String) -> NSAttributedString {
        let timeAttributes =
        [NSFontAttributeName: UIFont.boldSystemFontOfSize(10),
            NSForegroundColorAttributeName: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
            NSBackgroundColorAttributeName: UIColor.clearColor()]
        return NSAttributedString(string: text, attributes: timeAttributes)
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
        let font = UIFont.systemFontOfSize(16)
        let descriptionAttributes =
        [NSFontAttributeName:font,
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSBackgroundColorAttributeName: UIColor.clearColor(),
            NSParagraphStyleAttributeName: NSParagraphStyle.contentParagraphStyle(font)]
        return NSAttributedString(string: text, attributes: descriptionAttributes)
    }
    class func attributedStringForBookTitle(text :String) -> NSAttributedString {
        let timeAttributes =
        [NSFontAttributeName: UIFont.boldSystemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
            NSBackgroundColorAttributeName: UIColor.clearColor()]
        return NSAttributedString(string: text, attributes: timeAttributes)
    }
    class func attributedStringForLikeNode(text :String) -> NSAttributedString {
        let font = UIFont.systemFontOfSize(14)
        let likeAttributes =
        [NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
            NSBackgroundColorAttributeName: UIColor.clearColor(),
            NSParagraphStyleAttributeName: NSParagraphStyle.likeParagraphStyle(font)]
        let image = UIImage(named: "TimeLineLike")
        let likeAttributeString = NSMutableAttributedString(string: text, attributes: likeAttributes)
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        likeAttributeString.replaceCharactersInRange(NSMakeRange(0, 3), withAttributedString: NSAttributedString(attachment: textAttachment))
        
        return likeAttributeString
    }
    class func attributedStringForCommentNode(text :String) -> NSAttributedString {
        let font = UIFont.systemFontOfSize(14)
        let commentAttributes =
        [NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
            NSBackgroundColorAttributeName: UIColor.clearColor(),
            NSParagraphStyleAttributeName: NSParagraphStyle.likeParagraphStyle(font)]
        let image = UIImage(named: "TimeLineComment")
        let commentAttributeString = NSMutableAttributedString(string: text, attributes: commentAttributes)
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        commentAttributeString.replaceCharactersInRange(NSMakeRange(0, 3), withAttributedString: NSAttributedString(attachment: textAttachment))
        
        return commentAttributeString
    }
}

extension NSParagraphStyle {
    class func justifiedParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Justified
        return paragraphStyle.copy() as! NSParagraphStyle
    }
    class func contentParagraphStyle(font: UIFont) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Justified
        paragraphStyle.lineSpacing = 6
        paragraphStyle.paragraphSpacing = 6
        paragraphStyle.maximumLineHeight = font.lineHeight
        paragraphStyle.minimumLineHeight = font.lineHeight
        return paragraphStyle.copy() as! NSParagraphStyle
    }
    class func likeParagraphStyle(font: UIFont) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Justified
        paragraphStyle.maximumLineHeight = font.lineHeight
        paragraphStyle.minimumLineHeight = font.lineHeight
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
