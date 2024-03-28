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
  
  private let moviePage = MoviesPage(page: 1, totalPages: 2, movies: [.init(id: "1", title: "title", posterPath: "/1", releaseDate: nil)])
  
  override func setUp() {
    super.setUp()
    mockRepo = MoviesListRepositoryMock()
    sut = DefaultMoviesListUseCase(moviesRepository: mockRepo!)
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
  
  func testDefaultMoviesListUseCase_whenFailsToFetcsMovies_shouldThrowException() async throws {
    //Given
    let expectedError = NSError(domain: "Test", code: 500, userInfo: nil)
    mockRepo?.errorToThrow = expectedError
    //When
    let requestValue = MoviesListUseCaseRequestValue(page: 1)
    let expectation = XCTestExpectation(description: "Execute Failure")
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
    expectation.fulfill()
  }
}

