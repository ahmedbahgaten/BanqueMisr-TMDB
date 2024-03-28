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
    sut = DefaultMovieDetailsViewModel(movieDetailsUseCase: usecase,
                                       imgFetchingRepo: <#T##FetchImageRepository#>,
                                       movieID: "1")
  }
  
  override func tearDown() {
    super.tearDown()
    
  }
  
}
