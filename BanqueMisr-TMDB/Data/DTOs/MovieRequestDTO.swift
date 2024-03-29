//
//  MovieRequestDTO.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
import CoreData
struct MoviesRequestDTO: Encodable {
  let page: Int
}

extension MoviesRequestDTO {
  func toEntity(in context: NSManagedObjectContext) -> MoviesListRequestEntity {
    let entity: MoviesListRequestEntity = .init(context: context)
    entity.page = Int32(page)
    return entity
  }
}
