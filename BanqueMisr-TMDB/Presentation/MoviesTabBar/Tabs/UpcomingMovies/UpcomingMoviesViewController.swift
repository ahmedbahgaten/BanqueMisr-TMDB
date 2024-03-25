//
//  UpcomingMoviesViewController.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import UIKit

class UpcomingMoviesViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    setupView()
    view.backgroundColor = .gray
  }
  
  private func setupView() {
    tabBarItem.title = "Upcoming"
    tabBarItem.image = UIImage(systemName: "arrow.down.circle.dotted")
  }
}
