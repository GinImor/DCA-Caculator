//
//  APIService.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/14/21.
//  
//

import Foundation
import Combine

struct APIService {
  
  enum APIServiceError: Error {
    case encoding
    case badRequest
  }
  
  var API_KEY: String {
    keys.randomElement() ?? ""
  }

  let keys = ["5KWZZ65H75VB1EMK", "Y5CRF0QNGKOHI18B", "V79PRP4UZQX9UFCP"]
  
  func fetchSymbolsPublisher(query: String) -> AnyPublisher<SearchResults, Error> {
    switch parseQuery(text: query) {
    case .success(let keywords):
      let urlString =
        "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
      return publisherFor(urlString: urlString, docodeType: SearchResults.self)
    case .failure(let error):
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
  
  func fetchTimeSeriesMonthlyAdjustedPublisher(query: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {
    switch parseQuery(text: query) {
    case .success(let symbol):
      let urlString =
        "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
      return publisherFor(urlString: urlString, docodeType: TimeSeriesMonthlyAdjusted.self)
    case .failure(let error):
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
  
  private func publisherFor<Item>(urlString: String, docodeType: Item.Type) -> AnyPublisher<Item, Error>
  where Item: Decodable {
    guard let url = URL(string: urlString) else {
      return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()
    }
    return URLSession.shared.dataTaskPublisher(for: url)
      .map({ $0.data })
      .decode(type: Item.self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  private func parseQuery(text: String) -> Result<String, Error> {
    if let encodedQuery = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
      return .success(encodedQuery)
    } else {
      return .failure(APIServiceError.encoding)
    }
  }
  
}
