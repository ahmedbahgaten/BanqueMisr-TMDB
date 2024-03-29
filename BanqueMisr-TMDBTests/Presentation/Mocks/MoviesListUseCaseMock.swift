//
//  MoviesListUseCaseMock.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
@testable import BanqueMisr_TMDB

final class MoviesListUseCaseMock {
  
  var callCount = 0
  var moviesPages: MoviesPage?
  var error:NetworkError?
  var imageData:Data?
}

extension MoviesListUseCaseMock:MoviesListUseCase {
  func fetchMovieCellImage(for posterPath: String, width: Int) async throws -> Data {
    callCount += 1
    if let imageData = imageData {
      return imageData
    }else {
//      throw error
      return Data()
    }
  }
  
  func execute(for category: APIEndpoints.MoviesCategoryPath, requestValue: MoviesListUseCaseRequestValue) async throws -> MoviesPage {
    callCount += 1
    if let error = error {
      throw error
    }
    return moviesPages!
  }
}
