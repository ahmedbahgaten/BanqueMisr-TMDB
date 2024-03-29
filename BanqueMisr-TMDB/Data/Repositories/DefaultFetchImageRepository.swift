//
//  DefaultFetchImageRepository.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
final class DefaultFetchImageRepository {
  
  private let dataTransferService: DataTransferService
  private let localStorage:MoviePosterImageLocalStorage
  init(
    dataTransferService: DataTransferService,
    localStorage:MoviePosterImageLocalStorage) {
      self.dataTransferService = dataTransferService
      self.localStorage = localStorage
    }
  
  private func saveImage(data:Data, for imagePath:String) async throws {
    InMemoryImageCache.shared.setImage(data, forKey: imagePath)
    try await localStorage.saveImage(for: imagePath, data: data)
  }
}

extension DefaultFetchImageRepository: FetchImageRepository {
  
  func fetchImage(with imagePath: String, width: Int) async throws -> Data {
    if let inMemoryCachedImage = InMemoryImageCache.shared.getImage(forKey: imagePath) {
      return inMemoryCachedImage
    }else if let coreDataCachedImage = try await localStorage.getImage(for: imagePath) {
      return coreDataCachedImage
    }else {
      let endpoint = APIEndpoints.getMoviePoster(path: imagePath, width: width)
      let imageData = try await dataTransferService.request(with: endpoint)
      try await saveImage(data: imageData,
                          for: imagePath)
      return imageData
    }
  }
}
