//
//  MovieResponseDTO + Mapping.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
import CoreData
struct MoviesResponseDTO: Decodable {
  let page: Int
  let totalPages: Int
  let movies: [MovieDTO]
  
  private enum CodingKeys: String, CodingKey {
    case page
    case totalPages = "total_pages"
    case movies = "results"
  }
}

extension MoviesResponseDTO {
  struct MovieDTO: Decodable {
    let id: Int
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    
    private enum CodingKeys: String, CodingKey {
      case id
      case title
      case posterPath = "poster_path"
      case releaseDate = "release_date"
    }
  }
}

  // MARK: - Mappings
extension MoviesResponseDTO {
  func toDomain() -> MoviesPage {
    return .init(page: page,
                 totalPages: totalPages,
                 movies: movies.map { $0.toDomain() })
  }
}

extension MoviesResponseDTO.MovieDTO {
  func toDomain() -> Movie {
    return .init(id: Movie.Identifier(id),
                 title: title,
                 posterPath: posterPath,
                 releaseDate: releaseDate?.toDate)
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
