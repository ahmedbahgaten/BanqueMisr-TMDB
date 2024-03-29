//
//  MovieDetailsUseCase.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
protocol MovieDetailsUseCase {
  func execute(for movieID:String) async throws -> MovieDetails
  func fetchMovieImagePoster(for posterPath:String,width:Int) async throws -> Data
}

final class DefaultMovieDetailstUseCase {
    //MARK: - Properties
  private let movieDetailsRepository: MovieDetailsRepository
  private let movieDetailsMoviePosterRepo:FetchImageRepository
    //MARK: -Init
  init(movieDetailsRepository: MovieDetailsRepository,
       movieDetailsPosterRepo:FetchImageRepository) {
    self.movieDetailsRepository = movieDetailsRepository
    self.movieDetailsMoviePosterRepo = movieDetailsPosterRepo
  }
}

extension DefaultMovieDetailstUseCase:MovieDetailsUseCase {
  func execute(for movieID: String) async throws -> MovieDetails {
    return try await movieDetailsRepository.getMovieDetails(for: movieID)
  }
  
  func fetchMovieImagePoster(for posterPath:String,width:Int) async throws -> Data {
    return try await movieDetailsMoviePosterRepo.fetchImage(with: posterPath,
                                                            width: width)
  }

}
