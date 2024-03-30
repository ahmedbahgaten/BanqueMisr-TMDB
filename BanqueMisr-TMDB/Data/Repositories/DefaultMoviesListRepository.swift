//
//  DefaultMoviesRepository.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
final class DefaultMoviesListRepository {
  
  private let dataTransferService: DataTransferService
  private let localStorage:MoviesResponseLocalStorage
  
  init(dataTransferService: DataTransferService,
       localStorage:MoviesResponseLocalStorage) {
    self.dataTransferService = dataTransferService
    self.localStorage = localStorage
  }
}

extension DefaultMoviesListRepository:MoviesListRepository {
  func getRemoteMoviesList(for category:APIEndpoints.MoviesCategoryPath,
                           page: Int) async throws -> MoviesPage {
    let requestDTO = MoviesRequestDTO(page: page)
    do {
      let endpoint = APIEndpoints.getMovies(category: category,
                                            with: requestDTO)
      let responseDTO = try await self.dataTransferService.request(with: endpoint)
      try await localStorage.save(
        response: responseDTO,
        for: category.rawValue,
        and: requestDTO)
      return responseDTO.toDomain()
    }catch {
      if let cachedResponse = try await localStorage.getResponse(
        for: requestDTO,
        and: category.rawValue) {
        return cachedResponse.toDomain()
      }else {
        throw error
      }
    }
  }
}
