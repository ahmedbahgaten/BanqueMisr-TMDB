//
//  MoviesListUseCaseTests.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import XCTest
@testable import BanqueMisr_TMDB

final class MoviesListUseCaseTests: XCTestCase {
  
  private var sut:DefaultMoviesListUseCase?
  private var mockRepo:MoviesListRepositoryMock?
  private var imageRepoMock:FetchImageRepoMock?
  private let moviePage = MoviesPage(page: 1, totalPages: 2, movies: [.init(id: "1", title: "title", posterPath: "/1", releaseDate: nil)])
  
  override func setUp() {
    super.setUp()
    mockRepo = MoviesListRepositoryMock()
    imageRepoMock = FetchImageRepoMock()
    sut = DefaultMoviesListUseCase(moviesRepository: mockRepo!,
                                   imageFetcherRepo: imageRepoMock!)
  }
  
  override func tearDown() {
    super.tearDown()
    mockRepo = nil
    sut = nil
  }
  
  func testDefaultMoviesListUseCase_whenSuccessfullyFetctesMovies_shouldReturnMovies() async throws {
    //Given
    let expectedMoviesPage = moviePage
    mockRepo?.moviesPage = expectedMoviesPage
    //When
    let requestValue = MoviesListUseCaseRequestValue(page: 1)
    
    let result = try await sut?.execute(for: .nowPlaying,
                                   requestValue: requestValue)
    //Then
    XCTAssertEqual(result, expectedMoviesPage)
    XCTAssertEqual(mockRepo?.callCount, 1)
    XCTAssertEqual(mockRepo?.moviesPage?.movies.count, 1)
  }
  
  func testDefaultMoviesListUseCase_whenFailsToFetchMovies_shouldThrowException() async throws {
    //Given
    let expectedError = NSError(domain: "Test", code: 500, userInfo: nil)
    mockRepo?.errorToThrow = expectedError
    //When
    let requestValue = MoviesListUseCaseRequestValue(page: 1)
    //then
    do {
      _ = try await sut?.execute(for: .nowPlaying,
                                 requestValue: requestValue)
      XCTFail("Expected an error to be thrown")
    }catch let error as NSError {
      XCTAssertEqual(error, expectedError)
    }catch{
      XCTFail("Unexpected error thrown: \(error)")
    }
  }
  
  func testDefaultMoviesListUseCase_whenThereIsImageToDownload_shouldReturnImageData() async throws {
    let expectedImageData = "image data".data(using: .utf8)
    imageRepoMock?.data = expectedImageData
    let imageData = try await sut?.fetchMovieCellImage(for: "/3", width: 500)
    XCTAssertEqual(imageData, expectedImageData)
    XCTAssertEqual(imageRepoMock?.callcount, 1)
  }
  
  func testDefaultMoviesListUseCase_whenImageFailsToDownload_shouldThrowError() async throws {
    let expectedError = NetworkError.notConnected
    imageRepoMock?.error = expectedError
    do {
      _ = try await sut?.fetchMovieCellImage(for: "/3", width: 500)
      XCTFail("Should not download")
    }catch let error as NetworkError{
      XCTAssertEqual(error, expectedError)
    }catch {
      XCTFail("Unexpected error thrown: \(error)")
    }
  }
}

