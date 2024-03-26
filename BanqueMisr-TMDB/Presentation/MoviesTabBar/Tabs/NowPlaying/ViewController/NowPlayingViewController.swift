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
  private var dataSource:UITableViewDiffableDataSource<Int,MovieListItemViewModel>!
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
    setupTableView()
    setupDataSource()
    refreshApps([])
  }
  
  //MARK: - Methods
  private func setupView() {
    title = viewModel.screenTitle
  }
  
  private func setupBinding() {
    viewModel.loading.sink { self.setupLoading($0) }
      .store(in: &subscriptions)
  }
  
  private func setupTableView() {
    tableView.delegate = self
    let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    tableView.refreshControl = refreshControl
  }
  
  private func setupDataSource() {
    dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, movie in
      let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier,
                                               for: indexPath) as! MovieTableViewCell
      cell.setupCell(listItem: movie)
      return cell
    })
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
  
  private func reload(with data: [MovieListItemViewModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, MovieListItemViewModel>()
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
