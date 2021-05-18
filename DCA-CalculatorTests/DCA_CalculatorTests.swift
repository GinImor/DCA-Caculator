//
//  DCA_CalculatorTests.swift
//  DCA-CalculatorTests
//
//  Created by Gin Imor on 5/18/21.
//  
//

import XCTest
@testable import DCA_Calculator

class DCA_CalculatorTests: XCTestCase {
  
  var sut: DCAService!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    try super.setUpWithError()
    sut = DCAService()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    try super.tearDownWithError()
    sut = nil
  }
  
  func testCalculatedResult_givenGainingAndDCAIsUsed_ExpectPositiveGains() {
    // initial investment amount: 5000
    // monthly dollor cost averaging: 1500
    // initial date of investment index: 5
    let input = (5000, 1500, 5)
    let monthInfos = buildProfitableMonthInfos()
    let result = sut.calculate(input, monthInfos)
    
    XCTAssertNotNil(result)
    let notNilResult = result!
    
    // investement amount = 5000 + 1500 * 5
    XCTAssertEqual(notNilResult.investmentAmount, 12500)
    
    XCTAssertTrue(notNilResult.isProfitable)
    
    // initial investment amount / initial investment date adjusted open
    // averaging monthly amount / other investment date adjusted open
    // totalShares * shareValueOfNewestMonth
    XCTAssertEqual(notNilResult.currentValue, 17342.224, accuracy: 0.1)
    
    // current value - investment amount
    XCTAssertEqual(notNilResult.gain, 4842.224, accuracy: 0.1)
    
    // gain / investment amount
    XCTAssertEqual(notNilResult.yield, 0.3873, accuracy: 0.0001)
  }
  
  func testCalculatedResult_givenGainingAndDCAIsNotUsed_ExpectPositiveGains() {
    // initial investment amount: 5000
    // monthly dollor cost averaging: 0
    // initial date of investment index: 3
    let input = (5000, 0, 3)
    let monthInfos = buildProfitableMonthInfos()
    let result = sut.calculate(input, monthInfos)
    
    XCTAssertNotNil(result)
    let notNilResult = result!
    
    // investement amount = 5000 + 0 * 3
    XCTAssertEqual(notNilResult.investmentAmount, 5000)
    
    XCTAssertTrue(notNilResult.isProfitable)
    
    // initial investment amount / initial investment date adjusted open
    // averaging monthly amount / other investment date adjusted open
    // totalShares * shareValueOfNewestMonth
    XCTAssertEqual(notNilResult.currentValue, 6666.666, accuracy: 0.1)
    
    // current value - investment amount
    XCTAssertEqual(notNilResult.gain, 1666.666, accuracy: 0.1)
    
    // gain / investment amount
    XCTAssertEqual(notNilResult.yield, 0.3333, accuracy: 0.0001)
  }
  
  func testCalculatedResult_givenLosingAndDCAIsUsed_ExpectPositiveGains() {
    // initial investment amount: 5000
    // monthly dollor cost averaging: 1500
    // initial date of investment index: 5
    let input = (5000, 1500, 5)
    let monthInfos = buildNonProfitableMonthInfos()
    let result = sut.calculate(input, monthInfos)
    
    XCTAssertNotNil(result)
    let notNilResult = result!
    
    // investement amount = 5000 + 1500 * 5
    XCTAssertEqual(notNilResult.investmentAmount, 12500)
    
    XCTAssertFalse(notNilResult.isProfitable)
    
    // initial investment amount / initial investment date adjusted open
    // averaging monthly amount / other investment date adjusted open
    // totalShares * shareValueOfNewestMonth
    XCTAssertEqual(notNilResult.currentValue, 9189.323, accuracy: 0.1)
    
    // current value - investment amount
    XCTAssertEqual(notNilResult.gain, -3310.677, accuracy: 0.1)
    
    // gain / investment amount
    XCTAssertEqual(notNilResult.yield, -0.2648, accuracy: 0.0001)
  }
  
  func testCalculatedResult_givenLosingAndDCAIsNotUsed_ExpectPositiveGains() {
    // initial investment amount: 5000
    // monthly dollor cost averaging: 0
    // initial date of investment index: 3
    let input = (5000, 0, 3)
    let monthInfos = buildNonProfitableMonthInfos()
    let result = sut.calculate(input, monthInfos)
    
    XCTAssertNotNil(result)
    let notNilResult = result!
    
    // investement amount = 5000 + 0 * 3
    XCTAssertEqual(notNilResult.investmentAmount, 5000)
    
    XCTAssertFalse(notNilResult.isProfitable)
    
    // initial investment amount / initial investment date adjusted open
    // averaging monthly amount / other investment date adjusted open
    // totalShares * shareValueOfNewestMonth
    XCTAssertEqual(notNilResult.currentValue, 3666.666, accuracy: 0.1)
    
    // current value - investment amount
    XCTAssertEqual(notNilResult.gain, -1333.333, accuracy: 0.1)
    
    // gain / investment amount
    XCTAssertEqual(notNilResult.yield, -0.26666, accuracy: 0.0001)
  }
  
  private func buildNonProfitableMonthInfos() -> [MonthInfo] {
    let meta = Meta(symbol: "XYZ")
    let timeSeries = [
      "2021-06-21" : OHLC(open: "120", close: "110", adjustedClose: "110"),
      "2021-05-21" : OHLC(open: "130", close: "120", adjustedClose: "120"),
      "2021-04-21" : OHLC(open: "140", close: "130", adjustedClose: "130"),
      "2021-03-21" : OHLC(open: "150", close: "140", adjustedClose: "140"),
      "2021-02-21" : OHLC(open: "160", close: "150", adjustedClose: "150"),
      "2021-01-21" : OHLC(open: "170", close: "160", adjustedClose: "160"),
    ]
    return TimeSeriesMonthlyAdjusted(meta: meta, timeSeries: timeSeries).getMonthInfos()
  }
  
  private func buildProfitableMonthInfos() -> [MonthInfo] {
    let meta = Meta(symbol: "XYZ")
    let timeSeries = [
      "2021-01-31" : OHLC(open: "100", close: "110", adjustedClose: "110"),
      "2021-02-21" : OHLC(open: "110", close: "120", adjustedClose: "120"),
      "2021-03-21" : OHLC(open: "120", close: "130", adjustedClose: "130"),
      "2021-04-21" : OHLC(open: "130", close: "140", adjustedClose: "140"),
      "2021-05-21" : OHLC(open: "140", close: "150", adjustedClose: "150"),
      "2021-06-21" : OHLC(open: "150", close: "160", adjustedClose: "160"),
    ]
    return TimeSeriesMonthlyAdjusted(meta: meta, timeSeries: timeSeries).getMonthInfos()
  }
  
}

