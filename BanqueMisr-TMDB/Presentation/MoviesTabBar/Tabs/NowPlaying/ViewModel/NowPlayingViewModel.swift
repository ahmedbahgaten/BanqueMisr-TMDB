//
//  NowPlayingViewModel.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
import Combine

protocol NowPlayingViewModelInputs {
  func viewDidLoad()
  func didLoadNextPage()
  func didSelectItem(at index: Int)
}

enum MoviesListViewModelLoading {
  case fullScreen
  case nextPage
}

protocol NowPlayingViewModelOutputs {
  var loading: PassthroughSubject<MoviesListViewModelLoading?,Never> { get }
  var error: PassthroughSubject<String,Never> { get }
  var isEmpty: Bool { get }
  var screenTitle: String { get }
  var emptyDataTitle: String { get }
  var errorTitle: String { get }
}

typealias NowPlayingViewModel = NowPlayingViewModelInputs & NowPlayingViewModelOutputs

final class DefaultNowPlayingViewModel:NowPlayingViewModel {
  //MARK: - Properties
  private let moviesListUseCase:MoviesListUseCase
  private var pages :[MoviesPage] = []
  var currentPage:Int = 0
  var totalPageCount:Int = 1
  var hasMorePages:Bool { currentPage < totalPageCount }
  var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
  //MARK: - Outputs
  var loading: PassthroughSubject<MoviesListViewModelLoading?, Never> = .init()
  var error: PassthroughSubject<String, Never> = .init()
  var isEmpty: Bool { return true }
  var screenTitle: String { "Now Playing"}
  var emptyDataTitle: String { "Couldn't load Now Playing movies"}
  var errorTitle: String { "Error" }
  //MARK: - Init
  init(moviesListUseCase:MoviesListUseCase) {
    self.moviesListUseCase = moviesListUseCase
  }
  //MARK: - Methods
}
//MARK: - Inputs
extension DefaultNowPlayingViewModel {
  
  func viewDidLoad() {
    
  }
  
  func didLoadNextPage() {
    
  }
  
  func didSelectItem(at index: Int) {
    
  }
  
}
