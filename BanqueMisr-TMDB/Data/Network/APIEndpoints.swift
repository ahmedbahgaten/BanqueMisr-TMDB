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
  
  static func getMoviePoster(path: String, width: Int) -> Endpoint<Data> {
    
    let sizes = [92, 154, 185, 342, 500, 780]
    let closestWidth = sizes
      .enumerated()
      .min { abs($0.1 - width) < abs($1.1 - width) }?
      .element ?? sizes.first!
    
    return Endpoint(
      path: "t/p/w\(closestWidth)\(path)",
      method: .get,
      responseDecoder: DataResponseDecoder()
    )
  }
}
