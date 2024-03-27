//
//  AppTabBarController.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import UIKit

class AppTabBarController: OldTabBarStyle {
  
  let coordinator:[Coordinator]
  
  init(coordinator:[Coordinator]) {
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setViewControllers(coordinator.map { $0.navigationController } , animated: true)
  }
}

class OldTabBarStyle:UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  private func setup() {
    if #available(iOS 15.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = .systemBackground
      UITabBar.appearance().standardAppearance = appearance
      UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
    }
  }
}
