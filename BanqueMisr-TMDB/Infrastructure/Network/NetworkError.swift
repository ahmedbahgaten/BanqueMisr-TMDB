//
//  NetworkError.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation
protocol NetworkErrorLogger {
  func log(request: URLRequest)
  func log(responseData data: Data?, response: URLResponse?)
  func log(error: Error)
}

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
  init() { }
  
  func log(request: URLRequest) {
    print("-------------")
    print("request: \(request.url!)")
    print("headers: \(request.allHTTPHeaderFields!)")
    print("method: \(request.httpMethod!)")
    if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
      printIfDebug("body: \(String(describing: result))")
    } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
      printIfDebug("body: \(String(describing: resultString))")
    }
  }
  
  func log(responseData data: Data?, response: URLResponse?) {
    guard let data = data else { return }
    if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
      printIfDebug("responseData: \(String(describing: dataDict))")
    }
  }
  
  func log(error: Error) {
    printIfDebug("\(error)")
  }
}

enum NetworkError: Error {
  case error(statusCode: Int, data: Data?)
  case notConnected
  case cancelled
  case timeout
  case generic(Error)
  case urlGeneration
  
  var errorMessage:String {
    switch self {
      case .error(let statusCode,_):
        return "Something went wrong with statuscode \(statusCode)"
      case .notConnected:
        return "No internet connection"
      case .cancelled:
        return "Request is cancelled"
      case .timeout:
        return "Request timeout"
      case .generic:
        return "Something went wrong"
      case .urlGeneration:
        return "Invalid url request"
    }
  }
}
extension NetworkError:Equatable {
  static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    lhs.errorMessage == rhs.errorMessage
  }
}

extension NetworkError {
  var isNotFoundError: Bool { return hasStatusCode(404) }
  
  func hasStatusCode(_ codeError: Int) -> Bool {
    switch self {
      case let .error(code, _):
        return code == codeError
      default: return false
    }
  }
}
