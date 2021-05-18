//
//  DateSelectionController.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/17/21.
//  
//

import UIKit
import GILibrary

class DateSelectionController: GIListController<MonthInfo> {

  override var rowCellClass: GIListCell<MonthInfo>.Type? { DateSelectionCell.self }
  
  var didSelectMonthInfoAtIndex: ((Int) -> Void)?
  var selectedIndex: Int?
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath) as! DateSelectionCell
    cell.setRowFor(indexPath: indexPath, isSelected: selectedIndex == indexPath.row)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    didSelectMonthInfoAtIndex?(indexPath.row)
  }
}
