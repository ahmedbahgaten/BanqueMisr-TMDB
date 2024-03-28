//
//  PopularCoordinator.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
import UIKit

final class PopularCoordinator:Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  private let moviesListTableViewController:MoviesListTableViewController
  
  init(navigationController: UINavigationController,
       tableViewController:MoviesListTableViewController) {
    self.navigationController = navigationController
    self.moviesListTableViewController = tableViewController
  }
  
  func start() {
    let popularVC = PopularMoviesViewController(moviesListTableViewController: moviesListTableViewController)
    popularVC.tabBarItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis.circle")
    popularVC.tabBarItem.title = "Popular"
    popularVC.setCoordinator(self)
    navigationController.pushViewController(popularVC, animated: true)
  }
  
  func finish() { }
  
  func navigateToMovieDetails(with id:String) {
    let diContainer = AppDIContainer()
    let movieDetailsRepo = DefaultMovieDetailsRepository(dataTransferService: diContainer.apiDataTransferService)
    let movieDetailsUseCase = DefaultMovieDetailstUseCase(movieDetailsRepository: movieDetailsRepo)
    let viewModel = DefaultMovieDetailsViewModel(movieDetailsUseCase: movieDetailsUseCase,
                                                 movieID: id)
    let movieDetailsVC = MovieDetailsViewController(viewModel: viewModel)
    navigationController.pushViewController(movieDetailsVC, animated: true)
  }
  
}
