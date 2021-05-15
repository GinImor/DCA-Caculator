//
//  GIStack.swift
//  GILibrary
// 
//  Created by Gin Imor on 4/19/21.
//
//

import UIKit

public extension UIStackView {
  
  func spacing(_ value: CGFloat = 8.0) -> Self {
    spacing = value
    return self
  }
  
  func distributing(_ value: UIStackView.Distribution) -> Self {
    distribution = value
    return self
  }
  
  func aligning(_ value: UIStackView.Alignment) -> Self {
    alignment = value
    return self
  }
}

public class GIStack: UIStackView {
  
  private override init(frame: CGRect) {
    super.init(frame: .zero)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

public class GIHStack: GIStack {

  public convenience init(_ views: UIView...) {
    self.init(arrangedSubviews: views)
  }
  
  public convenience init(_ views: [UIView]) {
    self.init(arrangedSubviews: views)
  }
}

public class GIVStack: GIStack {
  
  public convenience init(_ views: UIView...) {
    self.init(arrangedSubviews: views)
    axis = .vertical
  }
  
  public convenience init(_ views: [UIView]) {
    self.init(arrangedSubviews: views)
    axis = .vertical
  }
}

