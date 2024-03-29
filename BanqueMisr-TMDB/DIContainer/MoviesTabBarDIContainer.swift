//
//  MoviesTabBarDIContainer.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation
import UIKit

protocol MoviesTabBarFlowCoordinatorDependencies {
  func makeNowPlayingMoviesCoordinator() -> Coordinator
  func makePopularMoviesCoordinator() -> Coordinator
  func makeUpcomingMoviesCoordinator() -> Coordinator
}

final class MoviesTabBarDIContainer {
  
  struct Dependencies {
    let apiDataTransferService: DataTransferService
    let imageDataTransferService: DataTransferService
  }
  
  //MARK: - Properties
  private let dependencies: Dependencies
  //MARK: Init
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  //MARK: - LocalStorage
  lazy var moviesResponseStorage:MoviesResponseLocalStorage = CoreDataMoviesResponseLocalStorage()
    // MARK: - Flow Coordinators
  func makeTabBarCoordinators() -> [Coordinator] {
    let nowPlayingCoordinator = makeNowPlayingMoviesCoordinator()
    let popularCoordinator = makePopularMoviesCoordinator()
    let upcomingCoordinator = makeUpcomingMoviesCoordinator()
    return [nowPlayingCoordinator,popularCoordinator,upcomingCoordinator]
  }
}

extension MoviesTabBarDIContainer:MoviesTabBarFlowCoordinatorDependencies {
  
  func makeNowPlayingMoviesCoordinator() -> Coordinator {
    let tableViewController = makeMoviesListTableViewController(for: .nowPlaying)
    let coordinator = NowPlayingCoordinator(navigationController: UINavigationController(),
                                            tableViewController: tableViewController)
    return coordinator
  }
  
  func makePopularMoviesCoordinator() -> Coordinator {
    let tableViewController = makeMoviesListTableViewController(for: .popular)
    let coordinator = PopularCoordinator(navigationController: UINavigationController(),
                                            tableViewController: tableViewController)
    return coordinator
  }
  
  func makeUpcomingMoviesCoordinator() -> Coordinator {
    let tableViewController = makeMoviesListTableViewController(for: .upcoming)
    let coordinator = UpcomingCoordinator(navigationController: UINavigationController(),
                                            tableViewController: tableViewController)
    return coordinator
  }
}
extension MoviesTabBarDIContainer {
  func makeMoviesListTableViewController(for moviesType:APIEndpoints.MoviesCategoryPath) -> MoviesListTableViewController {
    let viewModel = makeMoviesListViewModel(for: moviesType)
    let fetchImgRepo = makeMoviesListFetchImageRepo()
    return MoviesListTableViewController(viewModel: viewModel,
                                         fetchImageRepository: fetchImgRepo)
  }
  func makeMoviesListViewModel(for moviesType:APIEndpoints.MoviesCategoryPath) -> MoviesListViewModel {
    DefaultMoviesListViewModel(moviesListUseCase: makeMoviesListUseCase(), fetchImageRepo: makeMoviesListFetchImageRepo(),
                               moviesType: moviesType)
  }
  func makeMoviesListUseCase() -> MoviesListUseCase {
    DefaultMoviesListUseCase(moviesRepository: makeMoviesListRepository())
  }
  func makeMoviesListRepository() -> MoviesRepository {
    DefaultMoviesRepository(dataTransferService: dependencies.apiDataTransferService,
                            localStorage: moviesResponseStorage)
  }
  func makeMoviesListFetchImageRepo() -> FetchImageRepository {
    DefaultFetchImageRepository(dataTransferService: dependencies.imageDataTransferService)
  }
}
