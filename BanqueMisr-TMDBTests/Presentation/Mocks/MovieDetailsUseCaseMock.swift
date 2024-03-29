//
//  MovieDetailsUseCaseMock.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
@testable import BanqueMisr_TMDB

final class MovieDetailsUseCaseMock {
  
  var callCount = 0
  var movieDetails: MovieDetails?
  var error:NetworkError?
  var imageData:Data?
}
extension MovieDetailsUseCaseMock:MovieDetailsUseCase {
  func fetchMovieImagePoster(for posterPath: String, width: Int) async throws -> Data {
    callCount += 1
    if let imageData = imageData {
      return imageData
    }
    if let error = error {
      throw error
    }
    return imageData!
  }
  
  func execute(for movieID: String) async throws -> MovieDetails {
    callCount += 1
    if let error = error {
      throw error
    }
    return movieDetails!
  }
}
