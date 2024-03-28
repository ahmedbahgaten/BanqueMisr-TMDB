//
//  MovieDetails.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
struct MovieDetails {
  private let id:Int
  private let genres: [Genre]
  let overview: String
  let posterPath: String
  let runtime: Int
  private let spokenLanguages: [SpokenLanguage]
  private let budget:Int
  let status:String
  let title: String
  
  init(id:Int,
       genres: [MovieDetails.Genre],
       overview: String,
       posterPath: String,
       runtime: Int,
       spokenLanguages: [MovieDetails.SpokenLanguage],
       budget: Int,
       status: String,
       title: String) {
    self.id = id
    self.genres = genres
    self.overview = overview
    self.posterPath = posterPath
    self.runtime = runtime
    self.spokenLanguages = spokenLanguages
    self.budget = budget
    self.status = status
    self.title = title
  }
  
  var genresTxt:String {
    return genres.map(\.name).joined(separator: "-")
  }
  var spokenLangaugesTxt:String {
    spokenLanguages.map(\.name).joined(separator: "-")
  }
  var budgetTxt:String {
    return budget > 0 ? (budget.description + " $") : "Is not disclosed"
  }
  
  struct Genre {
    let id: Int
    let name: String
  }
  
  struct SpokenLanguage {
    let englishName, iso639_1, name: String
  }
}

extension MovieDetails:Equatable {
  static func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
    lhs.id == rhs.id
  }
}
