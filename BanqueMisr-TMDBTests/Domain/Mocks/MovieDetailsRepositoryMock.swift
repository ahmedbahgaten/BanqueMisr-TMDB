//
//  MovieDetailsRepositoryMock.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
@testable import BanqueMisr_TMDB
class MovieDetailsRepositoryMock {
    //MARK: - Properties
  var callCount = 0
  var movieDetails:MovieDetails?
  var errorToThrow:Error?
}
extension MovieDetailsRepositoryMock:MovieDetailsRepository {
  
  func getMovieDetails(for movieID: String) async throws -> MovieDetails {
    callCount += 1
    if let error = errorToThrow {
      throw error
    }
    guard let movieDetails = movieDetails else {
      throw NSError(domain: "", code: 0, userInfo: nil) // Throw some default error
    }
    return movieDetails
  }
}
