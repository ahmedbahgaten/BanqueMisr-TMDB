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

final class DefaultNowPlayingViewModel {
  //MARK: - Properties
  private let moviesListUseCase:MoviesListUseCase
  //MARK: - Init
  init(moviesListUseCase:MoviesListUseCase) {
    self.moviesListUseCase = moviesListUseCase
  }
  //MARK: - Methods
  
}
