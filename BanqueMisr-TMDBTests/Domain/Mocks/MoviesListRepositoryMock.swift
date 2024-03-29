//
//  MoviesListRepositoryMock.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
@testable import BanqueMisr_TMDB

class MoviesListRepositoryMock {
  //MARK: - Properties
  var callCount = 0
  var moviesPage:MoviesPage? = nil
  var errorToThrow:Error?
}
extension MoviesListRepositoryMock:MoviesListRepository {
  
  func getRemoteMoviesList(for category: APIEndpoints.MoviesCategoryPath, page: Int) async throws -> MoviesPage {
    callCount += 1
    if let error = errorToThrow {
      throw error
    }
    guard let moviesPage = moviesPage else {
      throw NSError(domain: "", code: 0, userInfo: nil) // Throw some default error
    }
    return moviesPage
  }
}
