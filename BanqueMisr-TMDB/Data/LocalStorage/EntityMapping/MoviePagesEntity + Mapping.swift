//
//  MoviePagesEntity + Mapping.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
import CoreData

extension MoviePagesEntity {
  func toDTO() -> MoviesResponseDTO {
    return .init(
      page: Int(page),
      totalPages: Int(totalPages),
      movies: movies?.allObjects.map { ($0 as! MovieEntity).toDTO() } ?? []
    )
  }
}

extension MovieEntity {
  func toDTO() -> MoviesResponseDTO.MovieDTO {
    return .init(id: Int(id ?? "")!,
          title: title,
          posterPath: posterPath,
          releaseDate: releaseDate)
  }
}

extension MoviesRequestDTO {
  func toEntity(in context: NSManagedObjectContext) -> MovieRequestEntity {
    let entity: MovieRequestEntity = .init(context: context)
    entity.page = Int32(page)
    return entity
  }
}

extension MoviesResponseDTO {
  func toEntity(in context: NSManagedObjectContext) -> MoviePagesEntity {
    let entity: MoviePagesEntity = .init(context: context)
    entity.page = Int32(page)
    entity.totalPages = Int32(totalPages)
    movies.forEach {
      entity.addToMovies($0.toEntity(in: context))
    }
    return entity
  }
}

extension MoviesResponseDTO.MovieDTO {
  func toEntity(in context: NSManagedObjectContext) -> MovieEntity {
    let entity: MovieEntity = .init(context: context)
    entity.id = id.description
    entity.title = title
    entity.posterPath = posterPath
    entity.releaseDate = releaseDate
    return entity
  }
}
