//
//  File.swift
//  BanqueMisr-TMDBTests
//
//  Created by Ahmed Bahgat on 29/03/2024.
//

import Foundation
@testable import BanqueMisr_TMDB

final class FetchImageRepoMock {
  var data:Data?
  var error:NetworkError?
  var callcount = 0
}

extension FetchImageRepoMock:FetchImageRepository {
  func fetchImage(with imagePath: String, width: Int) async throws -> Data {
    callcount += 1
    if let error = error {
      throw error
    }
    return data!
  }
}
