//
//  NowPlayingCoordinator.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
import UIKit

final class NowPlayingCoordinator:Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  private let moviesListTableViewController:MoviesListTableViewController
  
  init(navigationController: UINavigationController,
       tableViewController:MoviesListTableViewController) {
    self.navigationController = navigationController
    self.moviesListTableViewController = tableViewController
  }
  
  func start() {
    let nowPlayingVC = NowPlayingViewController(moviesListTableViewController: moviesListTableViewController)
    nowPlayingVC.tabBarItem.image = UIImage(systemName: "play.circle")
    nowPlayingVC.tabBarItem.title = "Now Playing"
    nowPlayingVC.setCoordinator(self)
    navigationController.pushViewController(nowPlayingVC, animated: true)
  }
  
  func finish() { }
  
  func navigateToMovieDetails(with id:String) {
    let diContainer = AppDIContainer()
    let movieDetailsRepo = DefaultMovieDetailsRepository(
      dataTransferService: diContainer.apiDataTransferService,
      movieDetailsLocalStorage: CoreDataMovieDetailsResponseLocalStorage()
    )
    let movieDetailsUseCase = DefaultMovieDetailstUseCase(
      movieDetailsRepository: movieDetailsRepo,
      movieDetailsPosterRepo: DefaultFetchImageRepository(
        dataTransferService: diContainer.apiDataTransferService,
        localStorage: CoreDataMoviePosterImageLocalStorage())
    )
    let viewModel = DefaultMovieDetailsViewModel(
      movieDetailsUseCase: movieDetailsUseCase,
      movieID: id
    )
    let movieDetailsVC = MovieDetailsViewController(viewModel: viewModel)
    navigationController.pushViewController(movieDetailsVC, animated: true)
  }
}
