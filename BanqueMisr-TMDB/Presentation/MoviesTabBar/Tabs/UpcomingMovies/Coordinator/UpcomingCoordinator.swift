//
//  UpcomingCoordinator.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
import UIKit
final class UpcomingCoordinator:Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  private let moviesListTableViewController:MoviesListTableViewController
  
  init(navigationController: UINavigationController,
       tableViewController:MoviesListTableViewController) {
    self.navigationController = navigationController
    self.moviesListTableViewController = tableViewController
  }
  
  func start() {
    let upcomingVC = UpcomingMoviesViewController(moviesListTableViewController: moviesListTableViewController)
    upcomingVC.tabBarItem.image = UIImage(systemName: "arrow.down.circle.dotted")
    upcomingVC.tabBarItem.title = "Upcoming"
    upcomingVC.setCoordinator(self)
    navigationController.pushViewController(upcomingVC, animated: true)
  }
  
  func finish() { }
  
}
