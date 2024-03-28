//
//  NetworkService.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation
protocol NetworkService {
  func request(endpoint:Requestable) async throws -> Data?
}
  // MARK: - Implementation
final class DefaultNetworkService {
  
  private let config: NetworkConfigurable
  private let sessionManager: NetworkSessionManager
  private let logger: NetworkErrorLogger
  
  init(
    config: NetworkConfigurable,
    sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
    logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
  ) {
    self.sessionManager = sessionManager
    self.config = config
    self.logger = logger
  }
  
  private func request(request: URLRequest) async throws -> Data {
    logger.log(request: request)
    do {
      let sessionDataTask = try await sessionManager.request(request)
      self.logger.log(responseData: sessionDataTask.data,
                      response: sessionDataTask.response)
      return sessionDataTask.data
    }catch {
      let error: NetworkError = self.resolve(error: error)
      self.logger.log(error: error)
      throw error
    }
  }
  
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

extension DefaultNetworkService: NetworkService {
  
  func request(endpoint: Requestable) async throws -> Data? {
    let urlRequest = try endpoint.urlRequest(with: config)
    return try await request(request: urlRequest)
  }
}

extension Dictionary where Key == String {
  func prettyPrint() -> String {
    var string: String = ""
    if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
      if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        string = nstr as String
      }
    }
    return string
  }
}

func printIfDebug(_ string: String) {
#if DEBUG
  print(string)
#endif
}
