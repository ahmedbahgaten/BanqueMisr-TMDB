//
//  DataTransferError.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation
enum DataTransferError: Error {
  case noResponse
  case parsing(Error)
  case networkFailure(NetworkError)
  case resolvedNetworkFailure(Error)
  
  var errorMessage:String {
    switch self {
      case .noResponse:
        return "No response"
      case .parsing:
        return "Could not show the data due to internal error"
      case .networkFailure(let networkError):
        return networkError.errorMessage
      case .resolvedNetworkFailure:
        return "Network failure"
    }
  }
}

protocol DataTransferErrorResolver {
  func resolve(error: NetworkError) -> Error
}

protocol DataTransferErrorLogger {
  func log(error: Error)
}
  // MARK: - Error Resolver
class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
  init() { }
  func resolve(error: NetworkError) -> Error {
    return error
  }
}
  // MARK: - Logger
final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
  init() { }
  
  func log(error: Error) {
    printIfDebug("-------------")
    printIfDebug("\(error)")
  }
}
