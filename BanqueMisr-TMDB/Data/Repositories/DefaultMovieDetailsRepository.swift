//
//  DefaultMovieDetailsRepository.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation

final class DefaultMovieDetailsRepository {
  
  private let dataTransferService: DataTransferService
  private let movieDetailsLocalStorage:MovieDetailsResponseLocalStorage
  
  init(dataTransferService: DataTransferService,
       movieDetailsLocalStorage:MovieDetailsResponseLocalStorage) {
    self.dataTransferService = dataTransferService
    self.movieDetailsLocalStorage = movieDetailsLocalStorage
  }
}

extension DefaultMovieDetailsRepository:MovieDetailsRepository {
  func getMovieDetails(for movieID: String) async throws -> MovieDetails {
    do {
      let endpoint = APIEndpoints.getMovieDetails(with: movieID)
      let responseDTO = try await self.dataTransferService.request(with: endpoint)
      try await movieDetailsLocalStorage.save(response: responseDTO,
                                              for: movieID)
      return responseDTO.toDomain()
    }catch {
      if let cachedMovieDetails = try await movieDetailsLocalStorage.getResponse(for: movieID) {
        return cachedMovieDetails.toDomain()
      }else {
        throw error
      }
    }
    
  }
}
