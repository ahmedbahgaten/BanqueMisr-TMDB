//
//  MoviesListViewModelTests.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import XCTest
@testable import BanqueMisr_TMDB

final class MoviesListViewModelTests: XCTestCase {
  
  private var sut:DefaultMoviesListViewModel?
  private var usecase:MoviesListUseCaseMock?
  
  let moviesPages: [MoviesPage] = {
    let page1 = MoviesPage(page: 1, totalPages: 2, movies: [
      Movie(id: "1", title: "title1", posterPath: "/1", releaseDate: nil),
      Movie(id: "2", title: "title2", posterPath: "/2", releaseDate: nil),
      Movie(id: "3", title: "title3", posterPath: "/3", releaseDate: nil)])
    let page2 = MoviesPage(page: 2, totalPages: 2, movies: [
      Movie(id: "4", title: "title4", posterPath: "/4", releaseDate: nil)])
    return [page1, page2]
  }()
  
  override func setUp() {
    super.setUp()
    usecase = MoviesListUseCaseMock()
    sut = DefaultMoviesListViewModel(moviesListUseCase: usecase!,
                                     moviesType: .nowPlaying)
  }
  
  override func tearDown() {
    super.tearDown()
    
  }
  
  func test_whenFetchMoviesCalled_whereListOfMoviesExist_shouldReturnMovies() async throws {
    usecase?.moviesPages = self.moviesPages.first
    _ = try await sut?.fetchMoviesList()
    XCTAssertEqual(sut!.currentPage, 1)
    XCTAssertTrue(sut!.hasMorePages)
    XCTAssertEqual(sut!.items.count, 3)
    XCTAssertEqual(usecase?.callCount, 1)
  }
  
  func test_whenFetchMoviesCalled_whereListOfMoviesIsEmpty_shouldReturnEmptyMovies() async throws {
    usecase?.moviesPages = MoviesPage(page: 1, totalPages: 1, movies: [])
    _ = try await sut?.fetchMoviesList()
    XCTAssertEqual(sut!.currentPage, 1)
    XCTAssertFalse(sut!.hasMorePages)
    XCTAssertEqual(sut!.items.count, 0)
    XCTAssertEqual(usecase?.callCount, 1)
  }
  
  func test_whenFetchMoviesCalled_whereReturnFirstPageOnly_viewModelShouldHaveFirstPageOnly() async throws {
    usecase?.moviesPages = moviesPages[0]
    let expectedItems = moviesPages[0].movies.map(MovieListItemViewModel.init)
    _ = try await sut?.fetchMoviesList()
    XCTAssertEqual(sut!.items, expectedItems)
    XCTAssertEqual(sut!.currentPage, 1)
    XCTAssertTrue(sut!.hasMorePages)
    XCTAssertEqual(usecase?.callCount, 1)
  }
  
  func test_whenFetchMoviesCalled_whereReturnFirstAndSecondPages_viewModelShouldHaveFirstAndSecondPages() async throws {
    usecase?.moviesPages = moviesPages[0]
    _ = try await sut?.fetchMoviesList()
    usecase?.moviesPages = moviesPages[1]
    _ = try await sut?.didLoadNextPage()
    let expectedItems = moviesPages.flatMap { $0.movies }.map(MovieListItemViewModel.init)
    XCTAssertEqual(sut!.items, expectedItems)
    XCTAssertEqual(sut!.currentPage, 2)
    XCTAssertFalse(sut!.hasMorePages)
    XCTAssertEqual(usecase?.callCount,2)
  }
  
  func test_whenFetchMoviesCalled_whereErrorIsThrown_viewModelShouldHaveError() async throws {
    let expectedError = NetworkError.timeout
    usecase?.error = expectedError
    do {
      _ = try await sut?.fetchMoviesList()
    }catch let error as NetworkError {
      XCTAssertEqual(error, expectedError)
      XCTAssertEqual(usecase?.callCount, 1)
    }catch {
      XCTFail("Unknown error type")
    }
  }
  
  func test_whenFetchMoviesCalled_whenLastPage_viewModelShouldHasMorePagesFalse() async throws {
    usecase?.moviesPages = moviesPages[1]
    _ = try await sut?.fetchMoviesList()
    _ = try await sut?.didLoadNextPage()
    XCTAssertFalse(sut!.hasMorePages)
  }
  
  func test_whenFetchMoviePoster_whenValidImgDataAvailable_viewModelShouldReturnData() async throws {
    let expectedData = "image data".data(using: .utf8)
    usecase?.imageData = expectedData
    let data = try await sut?.fetchPosterImage(posterImgPath: "/3", width: 400)
    XCTAssertEqual(data, expectedData)
    XCTAssertEqual(usecase?.callCount, 1)
  }
  
  func test_whenFetchMoviePoster_whenNetworkErrorIsThrown_viewModelShouldThrowError() async throws {
    let expectedError = NetworkError.cancelled
    usecase?.error = expectedError
    do {
      _ = try await sut?.fetchPosterImage(posterImgPath: "/3", width: 400)
    }catch let error as NetworkError {
      XCTAssertEqual(error, expectedError)
    }catch {
      XCTFail("Unknown error type is thrown")
    }
  }
}
