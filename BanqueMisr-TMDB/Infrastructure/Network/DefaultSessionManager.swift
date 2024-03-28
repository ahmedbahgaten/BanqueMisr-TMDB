//
//  DefaultSessionManager.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation

protocol NetworkSessionManager {
  func request(_ request:URLRequest) async throws -> (data:Data,response:URLResponse)
}
final class DefaultNetworkSessionManager {
  let session:URLSession = {
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = false
    config.requestCachePolicy = .reloadIgnoringCacheData 
    config.timeoutIntervalForResource = 60
    return URLSession(configuration: config)
  }()
  
  private func resolve(error: Error) -> NetworkError {
    let code = URLError.Code(rawValue: (error as NSError).code)
    switch code {
      case .notConnectedToInternet: return .notConnected
      case .cancelled: return .cancelled
      case .timedOut: return .timeout
      default: return .generic(error)
    }
  }
}
extension DefaultNetworkSessionManager:NetworkSessionManager {
  func request(_ request:URLRequest) async throws -> (data:Data,response:URLResponse) {
    do {
      let task = try await session.data(for: request)
      return task
    }catch {
      let error: NetworkError = self.resolve(error: error)
      throw error
    }
  }
}
