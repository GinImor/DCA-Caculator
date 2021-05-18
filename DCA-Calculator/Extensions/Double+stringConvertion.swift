//
//  Double+stringConvertion.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/17/21.
//  
//

import Foundation

extension Double {
  
  var stringValue: String { "\(self)" }
  
  var twoDigitString: String { String(format: "%.2f", self) }
  
  var currencyString: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: self as NSNumber) ?? twoDigitString
  }
  
  func toCurrency(hasCurrencySymbol: Bool = true, hasFractionDigits: Bool = true) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    if !hasCurrencySymbol {
      formatter.currencySymbol = ""
    }
    if !hasFractionDigits {
      formatter.maximumFractionDigits = 0
    }
    formatter.positivePrefix = "+"
    return formatter.string(from: self as NSNumber) ?? String(format: "%+.2f", self)
  }
  
  var percentage: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.positivePrefix = "+"
    formatter.maximumFractionDigits = 2
    return formatter.string(from: self as NSNumber) ?? String(format: "%+.2f%%", self)
  }
}
