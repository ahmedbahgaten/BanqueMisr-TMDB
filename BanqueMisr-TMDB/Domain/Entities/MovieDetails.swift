//
//  MovieDetails.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
struct MovieDetails {
  let genres: [Genre]
  let overview: String
  let posterPath: String
  let runtime: Int
  let spokenLanguages: [SpokenLanguage]
  let budget:Int
  let status:String
  let title: String
  
  
  var genresTxt:String {
    return genres.map(\.name).joined(separator: "-")
  }
  var spokenLangaugesTxt:String {
    spokenLanguages.map(\.name).joined(separator: "-")
  }
  
  struct Genre {
    let id: Int
    let name: String
  }
  
  struct SpokenLanguage {
    let englishName, iso639_1, name: String
  }
}
