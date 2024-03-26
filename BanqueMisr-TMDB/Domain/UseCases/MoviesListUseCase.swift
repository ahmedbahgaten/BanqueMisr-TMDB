//
//  MoviesListUseCase.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation

protocol MoviesListUseCase {
  func execute(for category:APIEndpoints.MoviesCategoryPath,
               requestValue: MoviesListUseCaseRequestValue) async throws -> MoviesPage
}

final class DefaultMoviesListUseCase {
  //MARK: - Properties
  private let moviesRepository: MoviesRepository
  //MARK: -Init
  init(moviesRepository: MoviesRepository) {
    self.moviesRepository = moviesRepository
  }
}

extension DefaultMoviesListUseCase:MoviesListUseCase {
  func execute(for category: APIEndpoints.MoviesCategoryPath, requestValue: MoviesListUseCaseRequestValue) async throws -> MoviesPage {
    return try await moviesRepository.getRemoteMoviesList(for: category, page: requestValue.page)
  }
}

struct MoviesListUseCaseRequestValue {
  let page: Int
}
