//
//  DataTransferService.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation
protocol DataTransferService {
  func request<T: Decodable, E: ResponseRequestable>(
    with endpoint: E) async throws -> T where E.Response == T
}

final class DefaultDataTransferService {
  
  private let networkService: NetworkService
  private let errorResolver: DataTransferErrorResolver
  private let errorLogger: DataTransferErrorLogger
  
  init(
    with networkService: NetworkService,
    errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
    errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
  ) {
    self.networkService = networkService
    self.errorResolver = errorResolver
    self.errorLogger = errorLogger
  }
}

extension DefaultDataTransferService: DataTransferService {
  
  func request<T: Decodable, E: ResponseRequestable>(
    with endpoint: E) async throws -> T where E.Response == T {
      do {
        let responseData = try await networkService.request(endpoint: endpoint)
        let decodedResponse: T = try self.decode(data: responseData,
                                          decoder: endpoint.responseDecoder)
        return decodedResponse
      }catch {
        self.errorLogger.log(error: error)
        throw error
      }
    }
  
  private func decode<T: Decodable>(
    data: Data?,
    decoder: ResponseDecoder
  ) throws -> T {
    do {
      guard let data = data else { throw DataTransferError.noResponse }
      let result: T = try decoder.decode(data)
      return result
    } catch {
      self.errorLogger.log(error: error)
      throw DataTransferError.parsing(error)
    }
  }
  
  private func resolve(networkError error: NetworkError) -> DataTransferError {
    let resolvedError = self.errorResolver.resolve(error: error)
    return resolvedError is NetworkError
    ? .networkFailure(error)
    : .resolvedNetworkFailure(resolvedError)
  }
}
