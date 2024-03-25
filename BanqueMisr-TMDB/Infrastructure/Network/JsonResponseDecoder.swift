//
//  JsonResponseDecoder.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation

protocol ResponseDecoder {
  func decode<T: Decodable>(_ data: Data) throws -> T
}

class JSONResponseDecoder: ResponseDecoder {
  private let jsonDecoder = JSONDecoder()
  init() { }
  func decode<T: Decodable>(_ data: Data) throws -> T {
    return try jsonDecoder.decode(T.self, from: data)
  }
}
