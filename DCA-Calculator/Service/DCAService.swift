//
//  DCAService.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/17/21.
//  
//

import Foundation

struct DCAService {
  
  func calculate(_ input: (Int?, Int?, Int?), _ monthInfos: [MonthInfo]) -> DCAResult? {
    guard let initialInvestment = input.0?.doubleValue,
          let monthlyDollarCostAveraging = input.1?.doubleValue,
          let initialDateOfInvestmentIndex = input.2
    else { return nil }
    let numberOfShares = getNumberOfShares(initialInvestment, monthlyDollarCostAveraging, initialDateOfInvestmentIndex, monthInfos)
    let latestShareValue = getLatestSharesValue(monthInfos)
    let currentValue = getCurrentValue(numberOfShares, latestShareValue)
    let investmentAmount = getInvestmentAmount(
      initialInvestment, monthlyDollarCostAveraging, initialDateOfInvestmentIndex.doubleValue)
    let gain = currentValue - investmentAmount
    let yield = gain / investmentAmount
    let annualReturn = getAnnualReturn(currentValue, investmentAmount, initialDateOfInvestmentIndex)
    return .init(currentValue: currentValue, investmentAmount: investmentAmount, gain: gain , yield: yield, annualReturn: annualReturn, isProfitable: currentValue > investmentAmount)
  }
  
  private func getInvestmentAmount(
    _ initialInvestment: Double,
    _ monthlyDollarCostAveraging: Double,
    _ initialDateOfInvestmentIndex: Double
  ) -> Double {
    var investmentAmount = initialInvestment
    investmentAmount += initialDateOfInvestmentIndex * monthlyDollarCostAveraging
    return investmentAmount
  }
  
  private func getCurrentValue(_ numberOfShares: Double, _ latestShareValue: Double) -> Double {
    return numberOfShares * latestShareValue
  }
  
  private func getNumberOfShares(_ initialInvestment: Double, _ monthlyDollarCostAveraging: Double, _ initialDateOfInvestmentIndex: Int, _ monthInfos: [MonthInfo]) -> Double {
    var numberOfShares = initialInvestment / monthInfos[initialDateOfInvestmentIndex].adjustedOpen
    monthInfos.prefix(initialDateOfInvestmentIndex).forEach {
      numberOfShares += monthlyDollarCostAveraging / $0.adjustedOpen
    }
    return numberOfShares
  }
  
  private func getLatestSharesValue(_ monthInfos: [MonthInfo]) -> Double {
    return monthInfos.first?.adjustedClose ?? 0
  }
  
  private func getAnnualReturn(_ currentValue: Double, _ investmentAmount: Double, _ initialDateOfInvestmentIndex: Int
  ) -> Double {
    let rate = currentValue / investmentAmount
    let years = ((initialDateOfInvestmentIndex.doubleValue + 1) / 12)
    return pow(rate, 1 / years) - 1
  }

}

struct DCAResult {
  let currentValue: Double
  let investmentAmount: Double
  let gain: Double
  let yield: Double
  let annualReturn: Double
  let isProfitable: Bool
}
