//
//  Movie.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
struct Movie: Equatable, Identifiable {
  typealias Identifier = String
  
  let id: Identifier
  let title: String?
  let posterPath: String?
  let releaseDate: Date?
}

struct MoviesPage: Equatable {
  let page: Int
  let totalPages: Int
  let movies: [Movie]
}
