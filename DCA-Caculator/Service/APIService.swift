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
  
  var API_KEY: String {
    keys.randomElement() ?? ""
  }

  let keys = ["5KWZZ65H75VB1EMK", "Y5CRF0QNGKOHI18B", "V79PRP4UZQX9UFCP"]
  
  func fetchSymbolsPublisher(searchTerm: String) -> AnyPublisher<SearchResults, Error> {
    let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(searchTerm)&apikey=\(API_KEY)"
    let url = URL(string: urlString)!
    return URLSession.shared.dataTaskPublisher(for: url)
      .map({ $0.data })
      .decode(type: SearchResults.self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
}
