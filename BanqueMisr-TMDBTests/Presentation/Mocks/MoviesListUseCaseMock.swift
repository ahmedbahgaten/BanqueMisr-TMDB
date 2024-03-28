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
  
}
extension MoviesListUseCaseMock:MoviesListUseCase {
  func execute(for category: APIEndpoints.MoviesCategoryPath, requestValue: MoviesListUseCaseRequestValue) async throws -> MoviesPage {
    callCount += 1
    if let error = error {
      throw error
    }
    return moviesPages!
  }
}
