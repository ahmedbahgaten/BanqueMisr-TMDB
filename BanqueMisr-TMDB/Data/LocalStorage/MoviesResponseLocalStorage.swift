//
//  MoviesResponseLocalStorage.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
import CoreData

protocol MoviesResponseLocalStorage {
  func getResponse(for request: MoviesRequestDTO,
                   and movieCategory:String) async throws -> MoviesResponseDTO?
  func save(response: MoviesResponseDTO,
            for movieCategory:String,
            and requestDto: MoviesRequestDTO) async throws
}

final class CoreDataMoviesResponseLocalStorage {
  
  private let coreDataStorage: CoreDataStorage
  
  init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
    self.coreDataStorage = coreDataStorage
  }
  
    // MARK: - Private
  
  private func fetchRequest(for requestDto: MoviesRequestDTO,
                            movieCategoryType:String) -> NSFetchRequest<MoviesListRequestEntity> {
    let request: NSFetchRequest = MoviesListRequestEntity.fetchRequest()
    request.predicate = NSPredicate(format: "%K = %d AND %K = %@",
                                    #keyPath(MoviesListRequestEntity.page), requestDto.page,
                                    #keyPath(MoviesListRequestEntity.movieCategoryType), movieCategoryType)
    return request
  }
  
  private func deleteResponse(for requestDto: MoviesRequestDTO,
                              for movieCategory:String,
                              in context: NSManagedObjectContext) throws  {
    let request = fetchRequest(for: requestDto,
                               movieCategoryType: movieCategory)
    
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
  func getResponse(for request: MoviesRequestDTO,
                   and movieCategory:String) async throws -> MoviesResponseDTO? {
    try await coreDataStorage.performBackgroundTask { [weak self] context in
      guard let self = self else { return nil }
      do {
        let fetchRequest = self.fetchRequest(for: request,
                                             movieCategoryType: movieCategory)
        let requestEntity = try context.fetch(fetchRequest).first
        return requestEntity?.moviePageEntity?.toDTO()
      }catch {
        throw CoreDataStorageError.readError(error)
      }
    }
  }
  
  func save(response responseDto: MoviesResponseDTO,
            for movieCategory:String,
            and requestDto: MoviesRequestDTO) async throws {
    try await coreDataStorage.performBackgroundTask { [weak self] context in
      guard let self = self else { return }
      do {
        try self.deleteResponse(for: requestDto,
                                for: movieCategory,
                                in: context)
        
        let requestEntity = requestDto.toEntity(in: context)
        requestEntity.moviePageEntity = responseDto.toEntity(in: context)
        requestEntity.movieCategoryType = movieCategory
        try context.save()
      } catch {
        throw CoreDataStorageError.saveError(error)
      }
    }
  }
}
