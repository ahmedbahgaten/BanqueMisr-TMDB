//
//  MoviesTabBarDIContainer.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation
import UIKit

protocol MoviesTabBarFlowCoordinatorDependencies {
  func makeNowPlayingMoviesViewController() -> UINavigationController
  func makePopularMoviesViewController() -> UINavigationController
  func makeUpcomingMoviesViewController() -> UINavigationController
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
    // MARK: - Flow Coordinators
  func makeAppTabBarController() -> AppTabBarController {
    let nowPlayingMoviesVC = makeNowPlayingMoviesViewController()
    let popularMoviesVC = makePopularMoviesViewController()
    let upcomingMoviesVC = makeUpcomingMoviesViewController()
    let tabBarController = AppTabBarController(viewControllers: [nowPlayingMoviesVC,popularMoviesVC,upcomingMoviesVC])
    return tabBarController
  }
  
  private func setupTabBarView(controller:UIViewController,
                               title:String,
                               imageName:String) {
    controller.tabBarItem.image = UIImage(systemName: imageName)
    controller.tabBarItem.title = title
  }
}

extension MoviesTabBarDIContainer:MoviesTabBarFlowCoordinatorDependencies {
  
  func makeNowPlayingMoviesViewController() -> UINavigationController {
    let nowPlayingVC = NowPlayingViewController()
    setupTabBarView(controller: nowPlayingVC,
                    title: "Now Playing",
                    imageName: "play.circle")
    return UINavigationController(rootViewController: nowPlayingVC)
  }
  
  func makePopularMoviesViewController() -> UINavigationController {
    let popularMoviesVC = PopularMoviesViewController()
    setupTabBarView(controller: popularMoviesVC,
                    title: "Popular",
                    imageName: "chart.line.uptrend.xyaxis.circle")
    return UINavigationController(rootViewController: popularMoviesVC)
  }
  
  func makeUpcomingMoviesViewController() -> UINavigationController {
    let upcomingMoviesVC = UpcomingMoviesViewController()
    setupTabBarView(controller: upcomingMoviesVC,
                    title: "Upcoming",
                    imageName: "arrow.down.circle.dotted")
    return UINavigationController(rootViewController: upcomingMoviesVC)
  }
}
