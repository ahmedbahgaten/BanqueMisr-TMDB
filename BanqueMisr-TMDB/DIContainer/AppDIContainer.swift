//
//  AppDIContainer.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 25/03/2024.
//

import Foundation

final class AppDIContainer {
  lazy var appConfiguration = AppConfiguration()
  
    // MARK: - Network
  lazy var apiDataTransferService: DataTransferService = {
    let config = ApiDataNetworkConfig(
      baseURL: URL(string: appConfiguration.apiBaseURL)!,
      queryParameters: [
        "api_key": appConfiguration.apiKey,
        "language": NSLocale.preferredLanguages.first ?? "en"
      ]
    )
    
    let apiDataNetwork = DefaultNetworkService(config: config)
    return DefaultDataTransferService(with: apiDataNetwork)
  }()
  
  lazy var imageDataTransferService: DataTransferService = {
    let config = ApiDataNetworkConfig(
      baseURL: URL(string: appConfiguration.imagesBaseURL)!
    )
    let imagesDataNetwork = DefaultNetworkService(config: config)
    return DefaultDataTransferService(with: imagesDataNetwork)
  }()
  
    // MARK: - DIContainers of scenes
  func makeMoviesTabBarDIContainer() -> MoviesTabBarDIContainer {
    return MoviesTabBarDIContainer()
  }
}
