//
//  NetworkConfigurableMock.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
@testable import BanqueMisr_TMDB

final class NetworkConfigurableMock: NetworkConfigurable {
  var baseURL: URL = URL(string: "https://test.com")!
  var headers: [String: String] = [:]
  var queryParameters: [String: String] = [:]
}
