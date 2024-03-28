//
//  NetworkSessionManagerMock.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
@testable import BanqueMisr_TMDB

enum NetworkErrorMock: Error {
  case notConnected
}

final class NetworkSessionManagerMock:NetworkSessionManager {
  var callCount = 0
  var data: Data?
  var error:NetworkError?
  
  func request(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
    callCount += 1
    if let error = error {
      throw error
    }
    guard let data = data else {
      throw NetworkError.generic(NSError(domain: "Test",
                                         code: 500, userInfo: nil))
    }
    return (data,URLResponse())
  }
}

