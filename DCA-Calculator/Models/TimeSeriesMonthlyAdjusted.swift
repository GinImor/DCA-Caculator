//
//  TimeSeriesMonthlyAdjusted.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/16/21.
//  
//

import Foundation

struct MonthInfo {
  let date: Date
  let adjustedOpen: Double
  let adjustedClose: Double
}

struct TimeSeriesMonthlyAdjusted: Decodable {
  let meta: Meta
  let timeSeries: [String: OHLC]
  enum CodingKeys: String, CodingKey {
    case meta = "Meta Data"
    case timeSeries = "Monthly Adjusted Time Series"
  }
  
  func getMonthInfos() -> [MonthInfo] {
    
    enum PasingError: Error { case badData }
    
    let monthInfos: [MonthInfo]? = try? timeSeries.sorted { $0.key > $1.key }.map { key, OHLC in
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      guard let date = dateFormatter.date(from: key),
            let adjustedOpen = getAdjustedOpen(OHLC),
            let adjustedClose = Double(OHLC.adjustedClose) else { throw PasingError.badData }
      return MonthInfo(date: date, adjustedOpen: adjustedOpen, adjustedClose: adjustedClose)
    }
    return monthInfos ?? []
  }
  
  private func getAdjustedOpen(_ OHLC: OHLC) -> Double? {
    guard let open = Double(OHLC.open), let adjustedClose = Double(OHLC.adjustedClose),
          let close = Double(OHLC.close) else { return nil }
    return open * (adjustedClose / close)
  }
}

struct OHLC: Decodable {
  let open, close, adjustedClose: String
  enum CodingKeys: String, CodingKey {
    case open = "1. open"
    case close = "4. close"
    case adjustedClose = "5. adjusted close"
  }
}

struct Meta: Decodable {
  let symbol: String
  enum CodingKeys: String, CodingKey {
    case symbol = "2. Symbol"
  }
}
