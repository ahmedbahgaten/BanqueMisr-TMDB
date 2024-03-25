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
  func request(_ request:URLRequest) async throws -> (data:Data,response:URLResponse) {
    let task = try await URLSession.shared.data(for: request)
    return task
  }
}
