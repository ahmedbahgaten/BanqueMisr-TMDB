//
//  MoviesListTableViewController.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import UIKit
import Combine

protocol MoviesListTableViewDelegate:AnyObject {
  func didSelectMovie(with id:String)
  func showLoader(show:Bool)
}
final class MoviesListTableViewController: UITableViewController ,Alertable {
  //MARK: - Properties
  private let viewModel: MoviesListViewModel
  private let fetchImageRepository:FetchImageRepository
  private var nextPageLoadingSpinner: UIActivityIndicatorView?
  private var subscriptions = Set<AnyCancellable>()
  private let refresh = UIRefreshControl()
  private var dataSource:UITableViewDiffableDataSource<Int,MovieListItemUI>!
  weak var delegate:MoviesListTableViewDelegate?
  //MARK: - Init
  init(viewModel: MoviesListViewModel,
       fetchImageRepository: FetchImageRepository) {
    self.viewModel = viewModel
    self.fetchImageRepository = fetchImageRepository
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    //MARK: - ViewLifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinding()
    setupTableView()
    setupDataSource()
    setupRefreshControl()
    loadMovies()
  }
    //MARK: - Methods
  private func setupBinding() {
    viewModel.loading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] loading in
        self?.setupLoading(loading)
    }.store(in: &subscriptions)
    
    viewModel.errorMessage
      .receive(on: DispatchQueue.main)
      .sink { [weak self] errorMessage in
        self?.setupLoading(nil)
        self?.showAlert(title: "Error",
                        message: errorMessage,
                        preferredStyle: .alert)
      }.store(in: &subscriptions)
  }
  private func setupLoading(_ loading:MoviesListViewModelLoading?) {
    switch loading {
      case .fullScreen:
        delegate?.showLoader(show: true)
      case .nextPage:
        nextPageLoadingSpinner?.removeFromSuperview()
        let loaderSize: CGSize = .init(width: tableView.frame.size.width,
                                       height: 44)
        nextPageLoadingSpinner = tableView.makeActivityIndicator(size:loaderSize)
        tableView.tableFooterView = nextPageLoadingSpinner
      case nil:
        refresh.endRefreshing()
        tableView.tableFooterView = nil
        delegate?.showLoader(show: false)
    }
  }
}
//MARK: - LoadingMovies
extension MoviesListTableViewController {
  private func loadMovies() {
    Task { @MainActor in
      do {
        let pages = try await viewModel.fetchMoviesList()
        reload(with: pages)
      }catch {
        tableView.setEmptyMessage()
      }
    }
  }
  
  private func loadMoreMovies() {
    Task { @MainActor in
      let items = try await self.viewModel.didLoadNextPage()
      self.reload(with: items)
    }
  }
}
//MARK: -RefreshControl
extension MoviesListTableViewController {
  private func setupRefreshControl() {
    refresh.addTarget(self, action: #selector(refreshApps(_:)), for: .valueChanged)
    refresh.tintColor = .clear
    refresh.subviews.first?.alpha = 0
  }
  
  @objc
  private func refreshApps(_ sender: Any) {
    loadMovies()
  }
}
//MARK: - TableView methods
extension MoviesListTableViewController {
  
  private func setupTableView() {
    tableView.delegate = self
    let nib = UINib(nibName: MovieTableViewCell.reuseIdentifier,
                    bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    tableView.refreshControl = refresh
  }
  
  private func setupDataSource() {
    dataSource = .init(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, movie in
      guard let self = self else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier,
                                               for: indexPath) as! MovieTableViewCell
      cell.setupCell(listItem: movie,moviesListViewModel: viewModel)
      if indexPath.row == viewModel.items.count - 1 {
        loadMoreMovies()
      }
      return cell
    })
  }
  
  private func reload(with data: [MovieListItemUI]) {
    guard !data.isEmpty else {
      tableView.setEmptyMessage(viewModel.emptyDataTitle )
      return
    }
    self.tableView.removeEmptyMessage()
    var snapshot = NSDiffableDataSourceSnapshot<Int, MovieListItemUI>()
    snapshot.appendSections([0])
    snapshot.appendItems(data)
    dataSource.apply(snapshot)
    self.refresh.endRefreshing()
  }
}
//MARK: - TableViewDelegate
extension MoviesListTableViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedMovieId = viewModel.getSelectedMovieId(at: indexPath.row)
    delegate?.didSelectMovie(with: selectedMovieId)
  }
}
