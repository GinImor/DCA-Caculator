//
//  CalculatorController.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/17/21.
//  
//

import UIKit
import Combine

class CalculatorController: UITableViewController {
  
  @IBOutlet weak var symbolLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var investmentAmountCurrentLabel: UILabel!
  @IBOutlet var currencyLabels: [UILabel]!
  
  @IBOutlet weak var currentValueLabel: UILabel!
  @IBOutlet weak var investmentAmountLabel: UILabel!
  @IBOutlet weak var gainLabel: UILabel!
  @IBOutlet weak var yieldLabel: UILabel!
  @IBOutlet weak var annualReturnLabel: UILabel!
  
  @IBOutlet weak var initialInvestmentTextField: UITextField!
  @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
  @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
  
  @IBOutlet weak var dateSlider: UISlider!
  
  var subscribers: Set<AnyCancellable> = []
  let dcaService = DCAService()
  
  var asset: Asset?
  lazy var monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos() ?? []
  
  @Published private var initialDateOfInvestmentIndex: Int?
  @Published private var initialInvestment: Int?
  @Published private var monthlyDollarCostAveraging: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupTextFields()
    setupDateSlider()
    observeForm()
    resetViews()
  }
  
  private func observeForm() {
    // there are two way to change the index, dateSlider and dateSelectionController
    // when the index change, need to update ivestment textField and slider
    $initialDateOfInvestmentIndex.sink { [unowned self] (index) in
      guard let index = index else { return }
      self.dateSlider.value = index.floatValue
      self.initialDateOfInvestmentTextField.text = self.monthInfos[index].date.M4_y4
    }.store(in: &subscribers)
    
    publisherForTextField(initialInvestmentTextField)
      .sink { [weak self] (text) in
        self?.initialInvestment = Int(text)}
      .store(in: &subscribers)
    
    publisherForTextField(monthlyDollarCostAveragingTextField)
      .sink { [weak self] (text) in
        self?.monthlyDollarCostAveraging = Int(text) }
      .store(in: &subscribers)
    
    Publishers.CombineLatest3($initialInvestment, $monthlyDollarCostAveraging, $initialDateOfInvestmentIndex)
      .sink { [weak self] (input) in
        guard let strongSelf = self else { return }
        guard let result = strongSelf.dcaService.calculate(input, strongSelf.monthInfos) else { return }
        let valueColor: UIColor = result.isProfitable ? .systemGreen : .systemRed
        strongSelf.currentValueLabel.backgroundColor = result.isProfitable ? .themeGreenShade : .themeRedShade
        strongSelf.yieldLabel.textColor = valueColor
        strongSelf.annualReturnLabel.textColor = valueColor
        strongSelf.currentValueLabel.text = result.currentValue.currencyString
        strongSelf.investmentAmountLabel.text = result.investmentAmount.toCurrency(hasFractionDigits: false)
        strongSelf.gainLabel.text = result.gain.toCurrency(hasCurrencySymbol: false, hasFractionDigits: false)
        strongSelf.yieldLabel.text = result.yield.percentage.addBrackets()
        strongSelf.annualReturnLabel.text = result.annualReturn.percentage
      }
      .store(in: &subscribers)
  }
  
  private func publisherForTextField(_ textField: UITextField)
  -> Publishers.CompactMap<NotificationCenter.Publisher, String> {
    return NotificationCenter.default.publisher(
      for: UITextField.textDidChangeNotification,
      object: textField)
      .compactMap { ($0.object as? UITextField)?.text }
  }
  
  @IBAction func dateSliderValueDidChange(_ sender: UISlider) {
    initialDateOfInvestmentIndex = Int(sender.value)
  }
  
  private func setupDateSlider() {
    dateSlider.value = 0
    dateSlider.maximumValue = (monthInfos.count - 1).floatValue
  }
  
  private func setupTextFields() {
    initialInvestmentTextField.becomeFirstResponder()
    initialInvestmentTextField.addDoneButton()
    monthlyDollarCostAveragingTextField.addDoneButton()
    initialDateOfInvestmentTextField.delegate = self
  }
  
  private func setupViews() {
    navigationItem.title = asset?.searchResult.symbol
    symbolLabel.text = asset?.searchResult.symbol
    nameLabel.text = asset?.searchResult.name
    investmentAmountCurrentLabel.text = asset?.searchResult.currency
    currencyLabels.forEach { $0.text = asset?.searchResult.currency.addBrackets() }
  }
  
  private func resetViews() {
    currentValueLabel.text = "0.00"
    investmentAmountLabel.text = "0.00"
    gainLabel.text = "-"
    yieldLabel.text = "-"
    annualReturnLabel.text = "-"
  }
}

extension CalculatorController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField === initialDateOfInvestmentTextField {
      let dateSelectionController = DateSelectionController()
      dateSelectionController.list = monthInfos
      dateSelectionController.selectedIndex = initialDateOfInvestmentIndex
      dateSelectionController.didSelectMonthInfoAtIndex = { [weak self] index in
        self?.initialDateOfInvestmentIndex = index
        self?.navigationController?.popViewController(animated: true)
      }
      navigationController?.pushViewController(dateSelectionController, animated: true)
      return false
    }
    return true
  }
}

