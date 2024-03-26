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
  func getRemoteMoviesList(for category:APIEndpoints.MoviesCategoryPath,
                           page: Int) async throws -> MoviesPage {
    let requestDTO = MoviesRequestDTO(page: page)
    let endpoint = APIEndpoints.getMovies(category: category,
                                          with: requestDTO)
    let responseDTO = try await self.dataTransferService.request(with: endpoint)
    return responseDTO.toDomain()
    
  }
}
