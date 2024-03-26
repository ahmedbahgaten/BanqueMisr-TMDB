//
//  NowPlayingViewModel.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
import Combine

protocol NowPlayingViewModelInputs {
  func fetchMoviesList(loading:MoviesListViewModelLoading) async throws -> [NowPlayingListItemViewModel]
  func didLoadNextPage() async throws -> [NowPlayingListItemViewModel]
  func didSelectItem(at index: Int)
}

enum MoviesListViewModelLoading {
  case fullScreen
  case nextPage
}

protocol NowPlayingViewModelOutputs {
  var loading: PassthroughSubject<MoviesListViewModelLoading?,Never> { get }
  var isEmpty: Bool { get }
  var screenTitle: String { get }
  var emptyDataTitle: String { get }
}

typealias NowPlayingViewModel = NowPlayingViewModelInputs & NowPlayingViewModelOutputs

final class DefaultNowPlayingViewModel:NowPlayingViewModel {
  //MARK: - Properties
  private let moviesListUseCase:MoviesListUseCase
  private var pages :[MoviesPage] = []
  private var isCurrentlyFetching:Bool = false
  var currentPage:Int = 0
  var totalPageCount:Int = 1
  var hasMorePages:Bool { currentPage < totalPageCount }
  var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
  //MARK: - Outputs
  var loading: PassthroughSubject<MoviesListViewModelLoading?, Never> = .init()
  var isEmpty: Bool { pages.movies.isEmpty }
  var screenTitle: String { "Now Playing"}
  var emptyDataTitle: String { "Couldn't load Now Playing movies"}
  //MARK: - Init
  init(moviesListUseCase:MoviesListUseCase) {
    self.moviesListUseCase = moviesListUseCase
  }
  //MARK: - Private methods
  private func appendPage(_ moviesPage: MoviesPage) {
    currentPage = moviesPage.page
    totalPageCount = moviesPage.totalPages
    
    pages = pages
      .filter { $0.page != moviesPage.page }
    + [moviesPage]
  }
}
//MARK: - Inputs
extension DefaultNowPlayingViewModel {
  
  func fetchMoviesList(loading:MoviesListViewModelLoading) async throws -> [NowPlayingListItemViewModel] {
    self.loading.send(loading)
    self.isCurrentlyFetching = true
    let moviesList = try await moviesListUseCase.execute(for: .nowPlaying,
                                                         requestValue: .init(page: nextPage))
    self.appendPage(moviesList)
    self.loading.send(.none)
    self.isCurrentlyFetching = false
    return pages.movies.map(NowPlayingListItemViewModel.init)
  }
  
  func didLoadNextPage() async throws -> [NowPlayingListItemViewModel] {
    guard hasMorePages, !isCurrentlyFetching else {
      return pages.movies.map(NowPlayingListItemViewModel.init)
    }
    return try await fetchMoviesList(loading: .nextPage)
  }
  
  func didSelectItem(at index: Int) {
    
  }
  
}
//MARK: - Private extension
private extension Array where Element == MoviesPage {
  var movies: [Movie] { flatMap { $0.movies } }
}
