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
  
}
