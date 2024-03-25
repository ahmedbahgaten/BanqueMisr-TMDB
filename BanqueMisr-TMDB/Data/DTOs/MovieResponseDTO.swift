//
//  MovieResponseDTO + Mapping.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
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
    private enum CodingKeys: String, CodingKey {
      case id
      case title
      case posterPath = "poster_path"
      case releaseDate = "release_date"
    }
    let id: Int
    let title: String?
    let posterPath: String?
    let releaseDate: String?
  }
}

  // MARK: - Mappings to Domain

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
