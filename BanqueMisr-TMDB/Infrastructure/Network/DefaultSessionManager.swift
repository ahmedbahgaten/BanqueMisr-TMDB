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
final class DefaultNetworkSessionManager: NetworkSessionManager {
  let session:URLSession = {
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = false
    config.requestCachePolicy = .reloadIgnoringCacheData 
    config.timeoutIntervalForResource = 60
    return URLSession(configuration: config)
  }()
  
  func request(_ request:URLRequest) async throws -> (data:Data,response:URLResponse) {
    let task = try await session.data(for: request)
    return task
  }
}
