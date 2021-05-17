//
//  CalculatorController.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/17/21.
//  
//

import UIKit

class CalculatorController: UITableViewController {
  
  @IBOutlet weak var symbolLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var investmentAmountCurrentLabel: UILabel!
  @IBOutlet var currencyLabels: [UILabel]!
  
  @IBOutlet weak var initialInvestmentTextField: UITextField!
  @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
  @IBOutlet weak var initialDateOfInvestment: UITextField!
  
  var asset: Asset?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupTextFields()
  }
  
  private func setupTextFields() {
    initialInvestmentTextField.addDoneButton()
    monthlyDollarCostAveragingTextField.addDoneButton()
    initialDateOfInvestment.delegate = self
  }
  
  private func setupViews() {
    symbolLabel.text = asset?.searchResult.symbol
    nameLabel.text = asset?.searchResult.name
    investmentAmountCurrentLabel.text = asset?.searchResult.currency
    currencyLabels.forEach { $0.text = asset?.searchResult.currency.addBrackets() }
  }
}

extension CalculatorController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField === initialDateOfInvestment {
      let dateSelectionController = UITableViewController()
      navigationController?.pushViewController(dateSelectionController, animated: true)
      return false
    }
    return true
  }
}
