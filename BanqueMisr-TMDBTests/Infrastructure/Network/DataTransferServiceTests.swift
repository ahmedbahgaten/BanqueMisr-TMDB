//
//  DataTransferServiceTests.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import XCTest
@testable import BanqueMisr_TMDB

final class DataTransferServiceTests: XCTestCase {
  
  private var sut:DefaultDataTransferService?
  private var sessionManager:NetworkSessionManagerMock?
  
  override func setUp() {
    super.setUp()
    let config = NetworkConfigurableMock()
    sessionManager = NetworkSessionManagerMock()
    let networkService = DefaultNetworkService(config: config,sessionManager: sessionManager!)
    sut = DefaultDataTransferService(with: networkService)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
  
  func test_whenGettingValidJson_shouldDecodeResponse() async throws {
    let responseData = #"{"name": "Ahmed Bahgat"}"#.data(using: .utf8)
    sessionManager?.data = responseData
    let endPoint = Endpoint<MockModel>(path: "http://test.com", method: .get)
    do {
      let result = try await sut?.request(with: endPoint)
      XCTAssertEqual(result?.name, "Ahmed Bahgat")
      XCTAssertEqual(sessionManager?.callCount, 1)
    }catch {
      XCTFail("Decoding failure")
    }
  }
  
  func test_whenGettingInvalidJson_shouldThrowParsingError() async throws {
    let responseData = #"{"job": "iOS Developer"}"#.data(using: .utf8)
    sessionManager?.data = responseData
    let endPoint = Endpoint<MockModel>(path: "http://test.com", method: .get)
    do {
      _ = try await sut?.request(with: endPoint)
      XCTFail("Should not decode the response")
    }catch let error as DataTransferError {
      XCTAssertEqual(error, .parsing(error))
    }catch {
      XCTFail("Unknown error type")
    }
  }
  
  func test_whenNoDataReceived_shouldThrowNoResponseError() async throws {
    let endPoint = Endpoint<MockModel>(path: "http://test.com", method: .get)
    do {
      _ = try await sut?.request(with: endPoint)
      XCTFail("Should not decode the response")
    }catch let error as DataTransferError {
      XCTAssertEqual(error, .noResponse)
    }catch {
      XCTFail("Unknown error type")
    }
  }
  
  
}
