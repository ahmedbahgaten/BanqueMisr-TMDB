//
//  MovieDetailsViewController.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import UIKit

class MovieDetailsViewController: UIViewController {
  
  @IBOutlet private weak var spokenLanguageLbl: UILabel!
  @IBOutlet private weak var moviePosterImgView: UIImageView!
  @IBOutlet private weak var stackView: UIStackView!
  @IBOutlet private weak var overviewLbl: UILabel!
  @IBOutlet private weak var runtimeLbl: UILabel!
  @IBOutlet private weak var budgetLbl: UILabel!
  @IBOutlet private weak var statusLbl: UILabel!
  @IBOutlet private weak var genresLbl: UILabel!
  
  private let viewModel:MovieDetailsViewModel
  
  init(viewModel: MovieDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    loadMovieDetails()
  }
  
  private func setupView() {
    moviePosterImgView.layer.cornerRadius = 8
  }
  
  private func loadMovieDetails() {
    Task {
      do {
        LoadingView.show()
        let details = try await viewModel.fetchMovieDetails()
        LoadingView.hide()
        renderMovieDetailsUI(movieDetails: details)
      }catch {
        
      }
    }
  }
  
  private func renderMovieDetailsUI(movieDetails:MovieDetails) {
    stackView.isHidden = false
    moviePosterImgView.isHidden = false
    overviewLbl.text = movieDetails.overview
    moviePosterImgView.image = ImageCacheManager.shared.getImage(forKey: movieDetails.posterPath)
    genresLbl.text = movieDetails.genresTxt
    runtimeLbl.text = movieDetails.runtime.description
    budgetLbl.text = movieDetails.budget.description + "$"
    statusLbl.text = movieDetails.status
    spokenLanguageLbl.text = movieDetails.spokenLangaugesTxt
  }
}
