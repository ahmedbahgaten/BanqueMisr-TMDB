//
//  MovieDetailsViewModelTests.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import XCTest
@testable import BanqueMisr_TMDB

final class MovieDetailsViewModelTests: XCTestCase {
  
  private var sut:DefaultMovieDetailsViewModel?
  private var usecase:MovieDetailsUseCaseMock?
  
  override func setUp() {
    super.setUp()
    usecase = MovieDetailsUseCaseMock()
    sut = DefaultMovieDetailsViewModel(movieDetailsUseCase: usecase!,
                                       movieID: "1")
  }
  
  override func tearDown() {
    super.tearDown()
    usecase = nil
    sut = nil
  }
  
  func test_fetchMovieDetails_whenMovieExists_shouldReturnMovie() async throws {
    //Given
    let expectedMovieDetails: MovieDetails = .init(id: 1,
                                                  genres: [],
                                                  overview: "overview",
                                                  posterPath: "/1",
                                                  runtime: 1,
                                                  spokenLanguages: [],
                                                  budget: 100_000_000,
                                                  status: "Released",
                                                  title: "Spider man")
    usecase?.movieDetails = expectedMovieDetails
    //When
    let movieDetails = try await sut?.fetchMovieDetails()
    //Then
    XCTAssertEqual(movieDetails, expectedMovieDetails)
  }
  
  func test_fetchMovieDetails_whenErrorExists_shouldThrowError() async throws {
    //Given
    let expectedError = NetworkError.timeout
    usecase?.error = expectedError
    //When
    do {
      _ = try await sut?.fetchMovieDetails()
    }catch let error as NetworkError {
      XCTAssertEqual(error, expectedError)
    }catch {
      XCTFail("Unexpected error type")
    }
  }
  
}
