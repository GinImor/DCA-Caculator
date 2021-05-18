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
    return timeSeries.sorted { $0.key > $1.key }.map { key, OHLC in
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let date = dateFormatter.date(from: key)!
      return MonthInfo(date: date, adjustedOpen: getAdjustedOpen(OHLC), adjustedClose: Double(OHLC.adjustedClose)!)
    }
  }
  
  private func getAdjustedOpen(_ OHLC: OHLC) -> Double {
    Double(OHLC.open)! * (Double(OHLC.adjustedClose)! / Double(OHLC.close)!)
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
