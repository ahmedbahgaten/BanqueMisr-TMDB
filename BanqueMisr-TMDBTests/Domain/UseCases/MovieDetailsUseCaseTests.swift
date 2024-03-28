//
//  MovieDetailsUseCaseTests.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import XCTest
@testable import BanqueMisr_TMDB

final class MovieDetailsUseCaseTests: XCTestCase {
  
  private var sut:DefaultMovieDetailstUseCase?
  private var mockRepo:MovieDetailsRepositoryMock?
  private let movieDetails = MovieDetails(id:1,
                                          genres: [],
                                          overview: "overview",
                                          posterPath: "/3",
                                          runtime: 1,
                                          spokenLanguages: [],
                                          budget: 100_000_000,
                                          status: "",
                                          title: "")
  
  override func setUp() {
    super.setUp()
    mockRepo = MovieDetailsRepositoryMock()
    sut = DefaultMovieDetailstUseCase(movieDetailsRepository: mockRepo!)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testMovieDetailsRepositoryMock_whenSuccessfullyFetctesMovieDetails_shouldReturnMovieDetails() async throws {
      //Given
    let expectedMovieDetails = movieDetails
    mockRepo?.movieDetails = expectedMovieDetails
      //When
    let movieID = "1"
    let result = try await sut?.execute(for: movieID)
      //Then
    XCTAssertEqual(result, expectedMovieDetails)
    XCTAssertEqual(mockRepo?.callCount, 1)
  }
  
  func testMovieDetailsRepositoryMock_whenFailsToFetcsMovieDetails_shouldThrowException() async throws {
      //Given
    let expectedError = NSError(domain: "Test", code: 500, userInfo: nil)
    mockRepo?.errorToThrow = expectedError
      //When
    let movieID = "1"
    let expectation = XCTestExpectation(description: "Execute Failure")
      //then
    do {
      _ = try await sut?.execute(for: movieID)
      XCTFail("Expected an error to be thrown")
    }catch let error as NSError {
      XCTAssertEqual(error, expectedError)
    }catch{
      XCTFail("Unexpected error thrown: \(error)")
    }
    expectation.fulfill()
  }
  
}
