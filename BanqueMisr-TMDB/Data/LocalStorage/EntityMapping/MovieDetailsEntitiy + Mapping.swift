//
//  MovieDetailsEntitiy + Mapping.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
import CoreData

extension MovieDetailsEntity {
  func toDTO() -> MovieDetailsDTO {
    let genresDTO = genres?.components(separatedBy: "-").map { MovieDetailsDTO.GenreDTO(id: 1, name: $0) }
    let spokenLangs = spokenLanguages?.components(separatedBy: "-").map {
      MovieDetailsDTO.SpokenLanguageDTO(englishName: $0,
                                        iso639_1: "",
                                        name: $0)
    }
    return MovieDetailsDTO(id: Int(id),
                 genres: genresDTO ?? [],
                 overview: overview ?? "",
                 posterPath: posterImagePath ?? "",
                 runtime: Int(runtime),
                 spokenLanguages: spokenLangs ?? [] ,
                 title: title ?? "",
                 status: status ?? "",
                 budget: Int(budget))
  }
}
extension MovieDetailsDTO {
  func toEntity(in context: NSManagedObjectContext) -> MovieDetailsEntity {
    let entity = MovieDetailsEntity(context: context)
    entity.id = Int32(id)
    entity.overview = overview
    entity.status = status
    entity.budget = Int64(budget)
    entity.posterImagePath = posterPath
    entity.runtime = Int32(runtime)
    entity.title = title
    entity.genres = genres.map { $0.name }.joined(separator: "-")
    entity.spokenLanguages = spokenLanguages.map {$0.name }.joined(separator: "-")
    return entity
  }
}
