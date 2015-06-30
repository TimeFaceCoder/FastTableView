//
//  NodeFramesetter.swift
//  Layers
//
//  Created by René Cacheaux on 9/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class FrameCalculator {
  class var textAreaHeight: CGFloat {
    return 300.0
  }
  
  class var cardWidth: CGFloat {
    return 320.0
  }

  class func frameForDescriptionText(containerBounds containerBounds: CGRect, featureImageFrame: CGRect) -> CGRect {
    return CGRect(x: 24.0, y: featureImageFrame.maxY + 20.0, width: containerBounds.width - 48.0, height: textAreaHeight)
  }
  
  class func frameForTitleText(containerBounds containerBounds: CGRect, featureImageFrame: CGRect) -> CGRect {
    var frameForTitleText = CGRect(x: 0, y: featureImageFrame.maxY - 70.0, width: containerBounds.width, height: 80)
    frameForTitleText.inset(dx: 20, dy: 20)
    return frameForTitleText
  }
  
  class func frameForGradient(featureImageFrame featureImageFrame: CGRect) -> CGRect {
    return featureImageFrame
  }
  
  class func frameForFeatureImage(featureImageSize featureImageSize: CGSize, containerFrameWidth: CGFloat) -> CGRect {
    let imageFrameSize = aspectSizeForWidth(containerFrameWidth, originalSize: featureImageSize)
    return CGRect(x: 0, y: 0, width: imageFrameSize.width, height: imageFrameSize.height)
  }
  
  class func frameForBackgroundImage(containerBounds containerBounds: CGRect) -> CGRect {
    return containerBounds
  }
  
  class func frameForContainer(featureImageSize featureImageSize: CGSize) -> CGRect {
    let containerWidth: CGFloat = cardWidth
    let size = sizeThatFits(CGSizeMake(containerWidth, CGFloat.max), withImageSize: featureImageSize)
    return CGRect(x: 0, y: 0, width: containerWidth, height: size.height)
  }
  
  class func sizeThatFits(size: CGSize, withImageSize imageSize: CGSize) -> CGSize {
    let imageFrameSize = aspectSizeForWidth(size.width, originalSize: imageSize)
    return CGSize(width: size.width, height: imageFrameSize.height + textAreaHeight)
  }
  
  class func aspectSizeForWidth(width: CGFloat, originalSize: CGSize) -> CGSize {
    let height =  ceil((originalSize.height / originalSize.width) * width)
    return CGSize(width: width, height: height)
  }
  
}
