//
//  EndpointMock.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
@testable import BanqueMisr_TMDB

struct EndpointMock: Requestable {
  var path: String
  var isFullPath: Bool = false
  var method: HTTPMethodType
  var headerParameters: [String: String] = [:]
  var queryParametersEncodable: Encodable?
  var queryParameters: [String: Any] = [:]
  var bodyParametersEncodable: Encodable?
  var bodyParameters: [String: Any] = [:]
  var bodyEncoder: BodyEncoder = JSONBodyEncoder()
  
  init(path: String, method: HTTPMethodType) {
    self.path = path
    self.method = method
  }
  }
