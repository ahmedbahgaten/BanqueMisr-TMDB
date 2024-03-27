//
//  AppCoordinator.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
import UIKit
protocol Coordinator:AnyObject {
  func start()
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }
  func finish()
}
