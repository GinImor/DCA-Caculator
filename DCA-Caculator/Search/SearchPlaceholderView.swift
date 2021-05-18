//
//  SearchPlaceholderView.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/15/21.
//  
//

import UIKit
import GILibrary

class SearchPlaceholderView: UIView {
  
  let imageView = UIImageView.new(imageName: "imLaunch", contentMode: .scaleAspectFit)
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Search for companies to calculate potential returns via dollar cose averaging"
    label.font = UIFont.primaryFont(style: .medium, size: 14)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    GIVStack(imageView.sizing(height: 88), titleLabel)
      .spacing(24).add(to: self).centering(self).sizing(.width, to: self, multiplier: 0.8)
  }
}
