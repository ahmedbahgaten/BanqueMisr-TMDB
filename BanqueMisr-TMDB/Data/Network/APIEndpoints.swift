//
//  APIEndpoints.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
struct APIEndpoints {
  
  enum MoviesCategoryPath:String {
    case nowPlaying = "now_playing"
    case popular = "popular"
    case upcoming = "upcoming"
  }
  
  static func getMovies(category:MoviesCategoryPath,
                        with moviesRequestDTO: MoviesRequestDTO) -> Endpoint<MoviesResponseDTO> {
    return Endpoint(
      path: "3/movie/\(category.rawValue)",
      method: .get,
      queryParametersEncodable: moviesRequestDTO
    )
  }
}
