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
  private var mockImageRepo:FetchImageRepoMock?
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
    mockImageRepo = FetchImageRepoMock()
    sut = DefaultMovieDetailstUseCase(movieDetailsRepository: mockRepo!,
                                      movieDetailsPosterRepo: mockImageRepo!)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testMovieDetailsUseCase_whenSuccessfullyFetchesMovieDetails_shouldReturnMovieDetails() async throws {
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
  
  func testMovieDetailsUseCase_whenFailsToFetchMovieDetails_shouldThrowException() async throws {
      //Given
    let expectedError = NSError(domain: "Test", code: 500, userInfo: nil)
    mockRepo?.errorToThrow = expectedError
      //When
    let movieID = "1"
      //then
    do {
      _ = try await sut?.execute(for: movieID)
      XCTFail("Expected an error to be thrown")
    }catch let error as NSError {
      XCTAssertEqual(error, expectedError)
    }catch{
      XCTFail("Unexpected error thrown: \(error)")
    }
  }
  
  func testMovieDetailsUseCase_whenDownloadingImage_shouldReturnImageData() async throws {
    //Given
    let expectedImageData = "image data".data(using: .utf8)
    //When
    mockImageRepo?.data = expectedImageData
    let imageData = try await sut?.fetchMovieImagePoster(for: "/3", width: 500)
    //Then
    XCTAssertEqual(imageData, expectedImageData)
    XCTAssertEqual(mockImageRepo?.callcount, 1)
  }
  
  func testMovieDetailsUseCase_whenFailstoDownloadImage_shouldThrowError() async throws {
    //Given
    let expectedError = NetworkError.timeout
    //When
    mockImageRepo?.error = expectedError
    do {
      _ = try await sut?.fetchMovieImagePoster(for: "/3", width: 500)
      XCTFail("Should throw error")
    }catch let error as NetworkError {
      //Then
      XCTAssertEqual(error, expectedError)
    }catch {
      XCTFail("Unknown error is thrown \(error)")
    }
    
  }
}
