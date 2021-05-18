//
//  Date+stringConversion.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/17/21.
//  
//

import Foundation

extension Date {
  
  var M4_y4: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
    return dateFormatter.string(from: self)
  }
}
