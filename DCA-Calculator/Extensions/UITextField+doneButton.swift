//
//  UITextField+doneButton.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/17/21.
//  
//

import UIKit

extension UITextField {
  
  func addDoneButton() {
    let screenWidth = UIScreen.main.bounds.width
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
    toolBar.items = [flexibleSpace, doneButton]
    toolBar.sizeToFit()
    inputAccessoryView = toolBar
  }
  
  @objc private func dismissKeyboard() {
    resignFirstResponder()
  }
}
