//
//  MoviesRepository.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
protocol MoviesRepository {
  func getRemoteMoviesList(for category:APIEndpoints.MoviesCategoryPath,
                           page: Int) async throws -> MoviesPage
}
