//
//  MovieDetailsViewModel.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
import Combine

protocol MovieDetailsViewModelInputs {
  func fetchMovieDetails() async throws -> MovieDetails
}

protocol MovieDetailsViewModelOutputs {
  var movieDetails:MovieDetails? { get }
}

typealias MovieDetailsViewModel = MovieDetailsViewModelInputs & MovieDetailsViewModelOutputs

final class DefaultMovieDetailsViewModel {
  //MARK: - Properties
  private let movieDetailsUseCase:MovieDetailsUseCase
  private let imgFetchingRepo:FetchImageRepository
  private let movieID:String
  var movieDetails: MovieDetails?
  
  init(movieDetailsUseCase: MovieDetailsUseCase,
       imgFetchingRepo: FetchImageRepository,
       movieID:String) {
    self.movieDetailsUseCase = movieDetailsUseCase
    self.imgFetchingRepo = imgFetchingRepo
    self.movieID = movieID
  }
}
extension DefaultMovieDetailsViewModel:MovieDetailsViewModel {
  func fetchMovieDetails() async throws -> MovieDetails {
    return try await movieDetailsUseCase.execute(for: self.movieID)
  }
}
