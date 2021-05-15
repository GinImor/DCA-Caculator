//
//  SearchCell.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/14/21.
//  
//

import UIKit
import GILibrary

class SearchCell: GIListCell<SearchResult> {
  
  private var assetSymbolLabel: UILabel = {
    let label = UILabel()
    label.text = "BA"
    label.font = UIFont.primaryFont(style: .demiBold, size: 18)
    return label
  }()
  
  private static func label2(text: String, fontSize: CGFloat, textColor: UIColor) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = UIFont.primaryFont(style: .regular, size: fontSize)
    label.textColor = textColor
    return label
  }
  
  private var assetTypeLabel = SearchCell.label2(text: "EQUITY USD", fontSize: 12, textColor: .lightGray)
  private var assetNameLabel = SearchCell.label2(text: "The Boeing Company", fontSize: 16, textColor: .black)
  
  override func setup() {
    super.setup()
    assetNameLabel.textAlignment = .right
    assetNameLabel.numberOfLines = 4
    GIHStack(
      GIVStack(assetSymbolLabel, assetTypeLabel.withCH(251, axis: .vertical)),
      GIVStack(assetNameLabel.sizing(width: 160))
    ).spacing().add(to: self).filling(self, edgeInsets: .init(8, 16))
  }
  
  override func didSetRow() {
    guard let row = row else { return }
    assetSymbolLabel.text = row.symbol
    assetNameLabel.text = row.name
    assetTypeLabel.text = "\(row.type) \(row.currency)"
  }
}
