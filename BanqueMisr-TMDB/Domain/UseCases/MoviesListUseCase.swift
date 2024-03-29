//
//  MoviesListUseCase.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation

protocol MoviesListUseCase {
  func execute(for category:APIEndpoints.MoviesCategoryPath,
               requestValue: MoviesListUseCaseRequestValue) async throws -> MoviesPage
  func fetchMovieCellImage(for posterPath:String,width:Int) async throws  -> Data
}

final class DefaultMoviesListUseCase {
  //MARK: - Properties
  private let moviesRepository: MoviesListRepository
  private let movieImagePosterFetcherRepo:FetchImageRepository
  //MARK: -Init
  init(moviesRepository: MoviesListRepository,
       imageFetcherRepo:FetchImageRepository) {
    self.moviesRepository = moviesRepository
    self.movieImagePosterFetcherRepo = imageFetcherRepo
  }
}

extension DefaultMoviesListUseCase:MoviesListUseCase {
  func execute(for category: APIEndpoints.MoviesCategoryPath, requestValue: MoviesListUseCaseRequestValue) async throws -> MoviesPage {
    return try await moviesRepository.getRemoteMoviesList(for: category, page: requestValue.page)
  }
  
  func fetchMovieCellImage(for posterPath: String,width:Int) async throws -> Data {
    return try await movieImagePosterFetcherRepo.fetchImage(with: posterPath,
                                                            width: width)
  }
  
}

struct MoviesListUseCaseRequestValue {
  let page: Int
}
