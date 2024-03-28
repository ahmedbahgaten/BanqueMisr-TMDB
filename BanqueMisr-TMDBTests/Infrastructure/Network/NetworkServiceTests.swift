//
//  NetworkServiceTests.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import XCTest
@testable import BanqueMisr_TMDB

final class NetworkServiceTests: XCTestCase {

  private var sut:DefaultNetworkService?
  private var networkConfig:NetworkConfigurableMock?
  private var sessionManager: NetworkSessionManagerMock?
  override func setUp() {
    super.setUp()
    networkConfig = NetworkConfigurableMock()
    sessionManager = NetworkSessionManagerMock()
    sut = DefaultNetworkService(config: networkConfig!,
                                sessionManager: sessionManager!)
  }
  
  override func tearDown() {
    super.tearDown()
    networkConfig = nil
    sessionManager = nil
    sut = nil
  }
  
  func test_whenMockedDataPassed_shouldReturnProperResponse() async throws {
    //Given
    let endPoint = EndpointMock(path: "http://test.com", method: .get)
    let expectedResponseData = "Response".data(using: .utf8) ?? Data()
    //When
    sessionManager?.data = expectedResponseData
    let data = try await sut?.request(endpoint: endPoint)
    //Then
    XCTAssertEqual(data, expectedResponseData)
    XCTAssertEqual(sessionManager?.callCount, 1)
  }
  
  func test_whenNoInternetConnection_shouldThrowError() async throws {
    //Given
    let endPoint = EndpointMock(path: "http://test.com", method: .get)
    let expectedError = NetworkError.notConnected
    //When
    sessionManager?.error = expectedError
    //Then
    do {
      _ = try await sut?.request(endpoint: endPoint)
      XCTFail("Expected an error to be thrown")
    }catch let error as NetworkError {
      XCTAssertEqual(error , expectedError)
    }catch {
      XCTFail("Unexpected error type \(error)")
    }
  }
  
  
}
