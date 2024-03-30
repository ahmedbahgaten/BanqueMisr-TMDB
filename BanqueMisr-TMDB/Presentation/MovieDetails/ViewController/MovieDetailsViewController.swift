//
//  MovieDetailsViewController.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController,Alertable {
    //MARK: - Properties
  private let viewModel:MovieDetailsViewModel
  private var subscriptions = Set<AnyCancellable>()
    //MARK: - Init
  init(viewModel: MovieDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
    //MARK: - Outlets
  @IBOutlet private weak var spokenLanguageLbl: UILabel!
  @IBOutlet private weak var moviePosterImgView: UIImageView!
  @IBOutlet private weak var stackView: UIStackView!
  @IBOutlet private weak var overviewLbl: UILabel!
  @IBOutlet private weak var runtimeLbl: UILabel!
  @IBOutlet private weak var budgetLbl: UILabel!
  @IBOutlet private weak var statusLbl: UILabel!
  @IBOutlet private weak var genresLbl: UILabel!
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupBinding()
    loadMovieDetails()
  }
  
  private func setupView() {
    moviePosterImgView.layer.cornerRadius = 8
    title = viewModel.screenTitle
  }
  
  private func setupBinding() {
    viewModel.errorMessage
      .receive(on: DispatchQueue.main)
      .sink {[weak self] errorMessage in
        self?.hideLoader()
        self?.showAlert(title: "Error",
                        message: errorMessage,
                        preferredStyle: .alert)
      }.store(in: &subscriptions)
    
    viewModel.isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isLoading in
        isLoading ? self?.showLoader() : self?.hideLoader()
      }.store(in: &subscriptions)
  }
  
  private func loadMovieDetails() {
    Task {
      let details = try await viewModel.fetchMovieDetails()
      let moviePoster = try await viewModel.fetchMovieImagePoster(
        for: details.posterPath,
        with: Int(moviePosterImgView.frame.size.width))
      renderMovieDetailsUI(movieDetails: details,
                           moviePosterImage: moviePoster)
    }
  }
  
  private func renderMovieDetailsUI(movieDetails:MovieDetails,
                                    moviePosterImage:Data) {
    stackView.isHidden = false
    moviePosterImgView.isHidden = false
    overviewLbl.text = movieDetails.overview
    genresLbl.text = movieDetails.genresTxt
    runtimeLbl.text = movieDetails.runtime.description
    budgetLbl.text = movieDetails.budgetTxt
    statusLbl.text = movieDetails.status
    spokenLanguageLbl.text = movieDetails.spokenLangaugesTxt
    let posterImage = UIImage(data: moviePosterImage)
    let imagePlaceholder = UIImage(named: "TMDB")
    moviePosterImgView.image = posterImage ?? imagePlaceholder
  }
}
