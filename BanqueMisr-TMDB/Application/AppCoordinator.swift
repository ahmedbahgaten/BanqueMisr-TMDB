//
//  AppCoordinator.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation
import UIKit

final class AppFlowCoordinator {
  
  var navigationController: UINavigationController
  private let appDIContainer: AppDIContainer
  
  init(
    navigationController: UINavigationController,
    appDIContainer: AppDIContainer
  ) {
    self.navigationController = navigationController
    self.appDIContainer = appDIContainer
  }
  
  func start() {
    
  }
}
