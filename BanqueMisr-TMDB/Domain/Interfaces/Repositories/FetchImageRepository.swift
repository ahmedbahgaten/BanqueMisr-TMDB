//
//  FetchImageRepository.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
protocol FetchImageRepository {
  func fetchImage(
    with imagePath: String,
    width: Int) async throws -> Data
}
