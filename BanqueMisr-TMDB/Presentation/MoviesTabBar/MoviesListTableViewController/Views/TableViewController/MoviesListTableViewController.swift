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
  private var dataSource:UITableViewDiffableDataSource<Int,MovieListItemViewModel>!
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
    setupView()
    setupBinding()
    setupTableView()
    setupDataSource()
    setupRefreshControl()
    refreshApps([])
  }
  
    //MARK: - Methods
  private func setupView() {
  }
  
  private func setupBinding() {
    viewModel.loading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] loading in
      DispatchQueue.main.async {
        self?.setupLoading(loading)
      }
    }
    .store(in: &subscriptions)
    
    viewModel.errorMessage
      .receive(on: DispatchQueue.main)
      .sink { [weak self] errorMessage in
        self?.setupLoading(nil)
        self?.showAlert(title: "Error",
                        message: errorMessage,
                        preferredStyle: .alert)
      }.store(in: &subscriptions)
  }
  
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
  
  private func loadMoreMovies() {
    Task { @MainActor [weak self] in
      let items = try await self?.viewModel.didLoadNextPage() ?? []
      self?.reload(with: items)
    }
  }
  
  private func setupRefreshControl() {
    refresh.addTarget(self, action: #selector(refreshApps(_:)), for: .valueChanged)
    refresh.tintColor = .clear
    refresh.subviews.first?.alpha = 0
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
        delegate?.showLoader(show: true)
      case .nextPage:
        nextPageLoadingSpinner?.removeFromSuperview()
        nextPageLoadingSpinner = tableView.makeActivityIndicator(size: .init(width: tableView.frame.size.width, height: 44))
        tableView.tableFooterView = nextPageLoadingSpinner
      case nil:
        refresh.endRefreshing()
        tableView.tableFooterView = nil
        delegate?.showLoader(show: false)
    }
  }
  
  private func loadMovies() {
    Task {
      do{
        let pages = try await viewModel.fetchMoviesList()
        reload(with: pages)
        self.refresh.endRefreshing()
      }catch {
        
      }
    }
  }
}
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
