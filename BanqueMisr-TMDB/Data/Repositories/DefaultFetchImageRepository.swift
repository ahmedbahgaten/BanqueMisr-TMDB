//
//  DefaultFetchImageRepository.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
final class DefaultFetchImageRepository {
  
  private let dataTransferService: DataTransferService  
  init(
    dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

extension DefaultFetchImageRepository: FetchImageRepository {
  
  func fetchImage(with imagePath: String, width: Int) async throws -> Data {
    let endpoint = APIEndpoints.getMoviePoster(path: imagePath, width: width)
    return try await dataTransferService.request(with: endpoint)
  }
}
