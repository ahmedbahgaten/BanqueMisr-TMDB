//
//  MovieDetailsDTO.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
struct MovieDetailsDTO: Codable {
  let genres: [GenreDTO]
  let overview: String
  let posterPath: String
  let runtime: Int
  let spokenLanguages: [SpokenLanguageDTO]
  let title: String
  let status:String
  let budget:Int
  
  enum CodingKeys: String, CodingKey {
    case genres
    case overview
    case posterPath = "poster_path"
    case runtime
    case status
    case title
    case spokenLanguages = "spoken_languages"
    case budget
  }
  
  struct GenreDTO: Codable {
    let id: Int
    let name: String
  }
  
  struct SpokenLanguageDTO: Codable {
    let englishName, iso639_1, name: String
    
    enum CodingKeys: String, CodingKey {
      case englishName = "english_name"
      case iso639_1 = "iso_639_1"
      case name
    }
  }
  
}

extension MovieDetailsDTO {
  func toDomain() -> MovieDetails {
    return .init(genres: genres.map { $0.toDomain() },
                 overview: overview,
                 posterPath: posterPath,
                 runtime: runtime,
                 spokenLanguages: spokenLanguages.map { $0.toDomain() },
                 budget: budget,
                 status: status,
                 title: title)
  }
}
extension MovieDetailsDTO.GenreDTO {
  func toDomain() -> MovieDetails.Genre {
    return .init(id: id, name: name)
  }
}
extension MovieDetailsDTO.SpokenLanguageDTO {
  func toDomain() -> MovieDetails.SpokenLanguage {
    return .init(englishName: englishName,
                 iso639_1: iso639_1,
                 name: name)
  }
}
