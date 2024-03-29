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
      movies: movies?.map { ($0 as! MovieEntity).toDTO() } ?? []
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
