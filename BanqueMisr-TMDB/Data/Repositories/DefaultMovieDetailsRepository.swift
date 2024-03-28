//
//  DefaultMovieDetailsRepository.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation

final class DefaultMovieDetailsRepository {
  
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

extension DefaultMovieDetailsRepository:MovieDetailsRepository {
  func getMovieDetails(for movieID: String) async throws -> MovieDetails {
    let endpoint = APIEndpoints.getMovieDetails(with: movieID)
    let responseDTO = try await self.dataTransferService.request(with: endpoint)
    return responseDTO.toDomain()
  }
}
