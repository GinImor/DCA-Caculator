//
//  SearchTableViewController.swift
//  DCA-Caculator
//
//  Created by Gin Imor on 5/14/21.
//  
//

import UIKit
import Combine
import GILibrary

class SearchTableViewController: GIListController<SearchResult>, UIAnimatable {
  
  enum Mode {
    case onBoarding, searching
  }
  
  override var rowCellClass: GIListCell<SearchResult>.Type? { SearchCell.self }
  
  private lazy var searchController: UISearchController = {
    let sc = UISearchController(searchResultsController: nil)
    sc.searchResultsUpdater = self
    sc.delegate = self
    sc.searchBar.placeholder = "Enter a company name or symbol"
    sc.searchBar.autocapitalizationType = .allCharacters
    sc.obscuresBackgroundDuringPresentation = false
    return sc
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    observeForm()
  }
  
  let apiService = APIService()
  private var subscribers: Set<AnyCancellable> = []
  
  @Published var searchQuery: String = ""
  @Published var mode: Mode = .onBoarding
  
  func observeForm() {
    $searchQuery
      .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
      .sink { [unowned self] (searchQuery) in
        guard !searchQuery.isEmpty else { return }
        self.performSearch(searchQuery: searchQuery)
      }
      .store(in: &subscribers)
    $mode.sink { [unowned self] (mode) in
      switch mode {
      case .onBoarding:
        self.tableView.backgroundView = SearchPlaceholderView()
      case .searching:
        self.tableView.backgroundView = nil
      }
    }.store(in: &subscribers)
  }
  
  override func setupTableView() {
    super.setupTableView()
    tableView.isScrollEnabled = false
  }
  
  func performSearch(searchQuery: String) {
    showLoadingAnimation()
    apiService.fetchSymbolsPublisher(query: searchQuery).sink { [unowned self] (completion) in
      self.hideLoadingAnimation()
      switch completion {
      case .failure(let error):
        print(error.localizedDescription)
      case .finished: ()
      }
    } receiveValue: { [unowned self] (searchResults) in
      self.setList(searchResults.items)
      self.tableView.isScrollEnabled = true
    }.store(in: &subscribers)
  }

  func setupNavigationBar() {
    navigationItem.searchController = searchController
    navigationItem.title = "Search"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedItem = list[indexPath.row]
    showLoadingAnimation()
    apiService.fetchTimeSeriesMonthlyAdjustedPublisher(query: selectedItem.symbol).sink { [weak self] (completion) in
      self?.hideLoadingAnimation()
      switch completion {
      case .failure(let error):
        print(error)
      case .finished: ()
      }
    } receiveValue: { [weak self] (adjusted) in
      let calculatorController = UIStoryboard(name: "Calculator", bundle: nil).instantiateViewController(withIdentifier: "Calculator") as! CalculatorController
      calculatorController.navigationItem.largeTitleDisplayMode = .never
      calculatorController.asset = Asset(searchResult: selectedItem, timeSeriesMonthlyAdjusted: adjusted)
      self?.navigationController?.pushViewController(calculatorController, animated: true)
      self?.searchController.searchBar.text = nil
    }.store(in: &subscribers)
  }
  
}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
    self.searchQuery = searchQuery
  }
  
  func willPresentSearchController(_ searchController: UISearchController) {
    mode = .searching
  }
  
}

