//
//  UIFont+constructor.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/15/21.
//  
//

import UIKit

extension UIFont {
  
  enum FontStyle: String {
    case medium
    case demiBold
    case bold
    case heavy
    case regular
  }
  
  static func primaryFont(style: FontStyle, size: CGFloat) -> UIFont {
    UIFont(name: "AvenirNext-\(style.rawValue.capitalized)", size: size)!
  }
}
