//
//  MoviesResponseLocalStorage.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
import CoreData

protocol MoviesResponseLocalStorage {
  func getResponse(for request: MoviesRequestDTO) async throws -> MoviesResponseDTO?
  func save(response: MoviesResponseDTO, for requestDto: MoviesRequestDTO) async throws
}

final class CoreDataMoviesResponseLocalStorage {
  
  private let coreDataStorage: CoreDataStorage
  
  init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
    self.coreDataStorage = coreDataStorage
  }
  
    // MARK: - Private
  
  private func fetchRequest(for requestDto: MoviesRequestDTO) -> NSFetchRequest<MoviesListRequestEntity> {
    let request: NSFetchRequest = MoviesListRequestEntity.fetchRequest()
    request.predicate = NSPredicate(format: "%K = %d",
                                    #keyPath(MoviesListRequestEntity.page), requestDto.page)
    return request
  }
  
  private func deleteResponse(for requestDto: MoviesRequestDTO,
                              in context: NSManagedObjectContext) throws  {
    let request = fetchRequest(for: requestDto)
    
    do {
      if let result = try context.fetch(request).first {
        context.delete(result)
      }
    } catch {
      throw CoreDataStorageError.deleteError(error)
    }
  }
}

extension CoreDataMoviesResponseLocalStorage: MoviesResponseLocalStorage {
  func getResponse(for request: MoviesRequestDTO) async throws -> MoviesResponseDTO? {
    try await coreDataStorage.performBackgroundTask { [weak self] context in
      guard let self = self else { return nil }
      do {
        let fetchRequest = self.fetchRequest(for: request)
        let requestEntity = try context.fetch(fetchRequest).first
        return requestEntity?.moviePageEntity?.toDTO()
      }catch {
        throw CoreDataStorageError.readError(error)
      }
    }
  }
  
  func save(response responseDto: MoviesResponseDTO,
            for requestDto: MoviesRequestDTO) async throws {
    try await coreDataStorage.performBackgroundTask { [weak self] context in
      guard let self = self else { return }
      do {
        try self.deleteResponse(for: requestDto, in: context)
        
        let requestEntity = requestDto.toEntity(in: context)
        requestEntity.moviePageEntity = responseDto.toEntity(in: context)
        try context.save()
      } catch {
        throw CoreDataStorageError.saveError(error)
      }
    }
  }
}
