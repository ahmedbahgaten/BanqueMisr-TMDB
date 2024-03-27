//
//  NowPlayingViewController.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import UIKit
import Combine

final class NowPlayingViewController: UIViewController {
    //MARK: - Properties
  private let moviesListTableViewController:MoviesListTableViewController
    //MARK: - Outlets
  @IBOutlet private weak var containerView: UIView!
    //MARK: - Init
  init(moviesListTableViewController:MoviesListTableViewController) {
    self.moviesListTableViewController = moviesListTableViewController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    //MARK: - ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addChildVC(moviesListTableViewController, into: containerView)
  }
  
  func navigateToMovieDetails(movieID:String) {
    
  }
}
