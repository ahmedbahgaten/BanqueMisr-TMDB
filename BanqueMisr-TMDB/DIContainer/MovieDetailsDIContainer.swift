//
//  MovieDetailsDIContainer.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
final class MovieDetailsDIContainer {
  
  struct Dependencies {
    let apiDataTransferService: DataTransferService
    let imageDataTransferService: DataTransferService
  }
  
    //MARK: - Properties
  private let dependencies: Dependencies
    //MARK: Init
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
}
