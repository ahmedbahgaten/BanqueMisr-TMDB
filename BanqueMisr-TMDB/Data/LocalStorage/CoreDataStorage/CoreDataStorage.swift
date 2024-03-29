//
//  CoreDataStorage.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
import CoreData

enum CoreDataStorageError: Error {
  case readError(Error)
  case saveError(Error)
  case deleteError(Error)
}

final class CoreDataStorage {
  static let shared = CoreDataStorage()
  
    // MARK: - PersistentContainer
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "BanqueMisr-TMDB")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
    // MARK: - Core Data SavingContext
  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
      }
    }
  }
  
  func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async rethrows -> T {
    return try await persistentContainer.performBackgroundTask(block)
  }
}
