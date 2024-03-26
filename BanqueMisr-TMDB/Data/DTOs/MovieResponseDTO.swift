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
      case genre
      case posterPath = "poster_path"
      case overview
      case releaseDate = "release_date"
    }
    enum GenreDTO: String, Decodable {
      case adventure
      case scienceFiction = "science_fiction"
    }
    let id: Int
    let title: String?
    let genre: GenreDTO?
    let posterPath: String?
    let overview: String?
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
                 genre: genre?.toDomain(),
                 posterPath: posterPath,
                 overview: overview,
                 releaseDate: releaseDate?.toDate)
  }
}

extension MoviesResponseDTO.MovieDTO.GenreDTO {
  func toDomain() -> Movie.Genre {
    switch self {
      case .adventure: return .adventure
      case .scienceFiction: return .scienceFiction
    }
  }
}
