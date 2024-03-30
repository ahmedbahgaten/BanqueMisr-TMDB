//
//  MoviePosterImageLocalStorage.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
import CoreData

protocol MoviePosterImageLocalStorage {
  func getImage(for posterPath:String) async throws -> Data?
  func saveImage(for posterPath: String,data:Data) async throws
}

final class CoreDataMoviePosterImageLocalStorage {
  private let coreDataStorage: CoreDataStorage
  
  init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
    self.coreDataStorage = coreDataStorage
  }
  
    // MARK: - Private
  
  private func fetchRequest(for posterPath: String) -> NSFetchRequest<MoviePosterImageEntity> {
    let request: NSFetchRequest = MoviePosterImageEntity.fetchRequest()
    request.predicate = NSPredicate(format: "%K = %@",
                                    #keyPath(MoviePosterImageEntity.posterPath), posterPath)
    return request
  }
  
  private func deleteResponse(for posterPath:String,
                              in context: NSManagedObjectContext) throws  {
    let request = fetchRequest(for: posterPath)
    
    do {
      if let result = try context.fetch(request).first {
        context.delete(result)
      }
    } catch {
      throw CoreDataStorageError.deleteError(error)
    }
  }
}

extension CoreDataMoviePosterImageLocalStorage:MoviePosterImageLocalStorage {
  func saveImage(for posterPath: String,data:Data) async throws {
    try await coreDataStorage.performBackgroundTask { context in
      do {
        try self.deleteResponse(for: posterPath, in: context)
        let imageEntity = MoviePosterImageEntity(context: context)
        imageEntity.posterPath = posterPath
        imageEntity.imageData = data
        try context.save()
      } catch {
        throw CoreDataStorageError.saveError(error)
      }
    }
  }
  
  func getImage(for posterPath: String) async throws -> Data? {
    try await coreDataStorage.performBackgroundTask { [weak self] context in
      guard let self = self else { return nil }
      do {
        let fetchRequest = self.fetchRequest(for: posterPath)
        let requestEntity = try context.fetch(fetchRequest).first
        return requestEntity?.imageData
      }catch {
        throw CoreDataStorageError.readError(error)
      }
    }
  }
}
