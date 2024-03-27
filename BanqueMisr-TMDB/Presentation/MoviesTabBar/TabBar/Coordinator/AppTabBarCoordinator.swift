//
//  AppTabBarCoordinator.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
class TabBarCoordinator {
  var childCoordinators: [Coordinator] = []
  let tabBarController: AppTabBarController
  
  init(tabBarController: AppTabBarController) {
    self.tabBarController = tabBarController
  }
  
  func start() {
    let nowPlayingCoordinator = tabBarController.coordinator.first { $0 is NowPlayingCoordinator } as! NowPlayingCoordinator
    let popularCoordinator = tabBarController.coordinator.first { $0 is PopularCoordinator } as! PopularCoordinator
    let upcomingCoordinator = tabBarController.coordinator.first { $0 is UpcomingCoordinator } as! UpcomingCoordinator
    
    childCoordinators.append(nowPlayingCoordinator)
    childCoordinators.append(popularCoordinator)
    childCoordinators.append(upcomingCoordinator)
    
    
    childCoordinators.forEach { $0.start() }
    tabBarController.setViewControllers(childCoordinators.map { $0.navigationController }, animated: false)
  }
  
  func finish() {
      // Clean up and notify parent coordinator (if applicable)
    childCoordinators.forEach { $0.finish() }
    childCoordinators.removeAll()
  }
}
