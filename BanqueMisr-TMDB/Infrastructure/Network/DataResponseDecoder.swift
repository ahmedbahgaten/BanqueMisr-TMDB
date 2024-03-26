//
//  DataResponseDecoder.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
class DataResponseDecoder: ResponseDecoder {
  init() { }
  
  enum CodingKeys: String, CodingKey {
    case `default` = ""
  }
  func decode<T: Decodable>(_ data: Data) throws -> T {
    if T.self is Data.Type, let data = data as? T {
      return data
    } else {
      let context = DecodingError.Context(
        codingPath: [CodingKeys.default],
        debugDescription: "Expected Data type"
      )
      throw Swift.DecodingError.typeMismatch(T.self, context)
    }
  }
}
