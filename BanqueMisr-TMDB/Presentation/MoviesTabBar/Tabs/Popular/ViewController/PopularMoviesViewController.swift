//
//  PopularMoviesViewController.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import UIKit

class PopularMoviesViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    setupView()
    view.backgroundColor = .green
  }
  
  private func setupView() {
    tabBarItem.title = "Popular"
    tabBarItem.image = UIImage(systemName: "play.circle")
  }
}
