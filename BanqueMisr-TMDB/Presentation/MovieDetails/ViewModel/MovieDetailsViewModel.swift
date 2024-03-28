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
  var errorMessage:PassthroughSubject<String,Never> { get }
  var isLoading:PassthroughSubject<Bool,Never> { get }
}

typealias MovieDetailsViewModel = MovieDetailsViewModelInputs & MovieDetailsViewModelOutputs

final class DefaultMovieDetailsViewModel {
  //MARK: - Properties
  private let movieDetailsUseCase:MovieDetailsUseCase
  private let movieID:String
  //MARK: - Outputs
  var errorMessage: PassthroughSubject<String, Never> = .init()
  var isLoading: PassthroughSubject<Bool, Never> = .init()
  //MARK: - Init
  init(movieDetailsUseCase: MovieDetailsUseCase,
       movieID:String) {
    self.movieDetailsUseCase = movieDetailsUseCase
    self.movieID = movieID
  }
}
extension DefaultMovieDetailsViewModel:MovieDetailsViewModel {
  func fetchMovieDetails() async throws -> MovieDetails {
    do {
      self.isLoading.send(true)
      let movieDetails = try await movieDetailsUseCase.execute(for: self.movieID)
      self.isLoading.send(false)
      return movieDetails
    }catch {
      errorMessage.send(error.errorMessage)
      throw error
    }
  }
}
