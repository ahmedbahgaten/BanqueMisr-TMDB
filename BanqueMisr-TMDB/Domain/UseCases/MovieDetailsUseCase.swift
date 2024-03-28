//
//  MovieDetailsUseCase.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
protocol MovieDetailsUseCase {
  func execute(for movieID:String) async throws -> MovieDetails
}

final class DefaultMovieDetailstUseCase {
    //MARK: - Properties
  private let movieDetailsRepository: MovieDetailsRepository
    //MARK: -Init
  init(movieDetailsRepository: MovieDetailsRepository) {
    self.movieDetailsRepository = movieDetailsRepository
  }
}

extension DefaultMovieDetailstUseCase:MovieDetailsUseCase {
  func execute(for movieID: String) async throws -> MovieDetails {
    return try await movieDetailsRepository.getMovieDetails(for: movieID)
  }
}
