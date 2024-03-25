//
//  DefaultMoviesRepository.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
final class DefaultMoviesRepository {
  
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

extension DefaultMoviesRepository:MoviesRepository {
  func getRemoteMoviesList(page: Int) async throws -> MoviesPage {
    return MoviesPage(page: 0, totalPages: 0, movies: [])
  }
}
