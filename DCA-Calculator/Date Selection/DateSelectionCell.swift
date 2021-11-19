//
//  DateSelectionCell.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/17/21.
//  
//

import UIKit
import GILibrary

class DateSelectionCell: GIListCell<MonthInfo> {
  
  let monthLabel = UILabel.new("December 2020", attributes: [.font: UIFont.primaryFont(style: .medium, size: 18)])
  let monthsAgoLabel = UILabel.new(
    "Recent", attributes: [.font: UIFont.primaryFont(style: .regular, size: 12), .foregroundColor: UIColor.darkGray])
  
  override func setup() {
    super.setup()
    vStack(monthLabel, monthsAgoLabel)
      .add(to: self).filling(self, edgeInsets: .init(8, 16))
  }
  
  func setRowFor(indexPath: IndexPath, isSelected: Bool) {
    monthLabel.text = row?.date.M4_y4
    switch indexPath.row {
    case 1: monthsAgoLabel.text = "1 month ago"
    case 0: monthsAgoLabel.text = "just invested"
    default: monthsAgoLabel.text = "\(indexPath.row) months ago"
    }
    accessoryType = isSelected ? .checkmark : .none
  }
}

