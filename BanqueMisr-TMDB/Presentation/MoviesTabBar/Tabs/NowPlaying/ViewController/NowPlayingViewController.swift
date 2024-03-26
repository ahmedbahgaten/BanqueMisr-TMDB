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
  private var viewModel:NowPlayingViewModel
  private var subscriptions = Set<AnyCancellable>()
  private let refreshControl = UIRefreshControl()
  private var dataSource:UITableViewDiffableDataSource<Int,NowPlayingListItemViewModel>!
  //MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  //MARK: - Init
  init(viewModel: NowPlayingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    //MARK: - ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupBinding()
    setupCollectionView()
  }
  
  //MARK: - Methods
  private func setupView() {
    title = viewModel.screenTitle
  }
  
  private func setupBinding() {
    viewModel.loading.sink { self.setupLoading($0) }
      .store(in: &subscriptions)
  }
  
  private func setupCollectionView() {
    tableView.delegate = self
    tableView.refreshControl = refreshControl
  }
  
  private func setupRefreshControl() {
    refreshControl.addTarget(self, action: #selector(refreshApps(_:)), for: .valueChanged)
    refreshControl.tintColor = .clear
    refreshControl.subviews.first?.alpha = 0
  }
  
  @objc
  private func refreshApps(_ sender: Any) {
    reload(with: [])
    loadMovies()
  }
  
  private func reload(with data: [NowPlayingListItemViewModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, NowPlayingListItemViewModel>()
    snapshot.appendSections([0])
    snapshot.appendItems(data)
    dataSource.apply(snapshot)
  }
  
  private func setupLoading(_ loading:MoviesListViewModelLoading?) {
    switch loading {
      case .fullScreen:
        return
      case .nextPage:
        return
      case nil:
        return
    }
  }
  
  private func loadMovies() {
    Task {
      do{
        let pages = try await viewModel.fetchMoviesList(loading: .fullScreen)
        reload(with: pages)
      }catch {
        
      }
    }
  }
}
extension NowPlayingViewController:UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
