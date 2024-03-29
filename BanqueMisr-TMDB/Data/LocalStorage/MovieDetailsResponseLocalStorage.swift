//
//  MovieDetailsResponseLocalStorage.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
import CoreData

protocol MovieDetailsResponseLocalStorage {
  func getResponse(for movieID: String) async throws -> MovieDetailsDTO?
  func save(response: MovieDetailsDTO, for movieID: String) async throws
}

final class CoreDataMovieDetailsResponseLocalStorage {
  
  private let coreDataStorage: CoreDataStorage
  
  init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
    self.coreDataStorage = coreDataStorage
  }
  
  private func fetchRequest(for movieID:String) -> NSFetchRequest<MovieDetailsRequestEntity> {
    let request: NSFetchRequest = MovieDetailsRequestEntity.fetchRequest()
    request.predicate = NSPredicate(format: "%K = %@",
                                    #keyPath(MovieDetailsRequestEntity.movieID), movieID)
    return request
  }
  
  private func deleteResponse(for movieID: String,
                              in context: NSManagedObjectContext) throws  {
    let request = fetchRequest(for: movieID)
    
    do {
      if let result = try context.fetch(request).first {
        context.delete(result)
      }
    } catch {
      throw CoreDataStorageError.deleteError(error)
    }
  }
}
extension CoreDataMovieDetailsResponseLocalStorage: MovieDetailsResponseLocalStorage {
  func getResponse(for movieID: String) async throws -> MovieDetailsDTO? {
    try await coreDataStorage.performBackgroundTask { [weak self] context in
      guard let self = self else { return nil }
      do {
        let fetchRequest = self.fetchRequest(for: movieID)
        let requestEntity = try context.fetch(fetchRequest).first
        return requestEntity?.movieDetailsEntity?.toDTO()
      }catch {
        throw CoreDataStorageError.readError(error)
      }
    }
  }
  func save(response: MovieDetailsDTO, for movieID: String) async throws {
    try await coreDataStorage.performBackgroundTask { [weak self] context in
      guard let self = self else { return }
      do {
        try self.deleteResponse(for: movieID, in: context)
        let requestEntity = MovieDetailsRequestEntity(context: context)
        requestEntity.movieID = movieID
        requestEntity.movieDetailsEntity = response.toEntity(in: context)
        try context.save()
      }catch {
        throw CoreDataStorageError.saveError(error)
      }
    }
  }
}
