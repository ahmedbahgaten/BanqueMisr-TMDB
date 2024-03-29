//
//  ImageCacheManager.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
import UIKit

class InMemoryImageCache {
  static let shared = InMemoryImageCache()
  private let cache = NSCache<NSString, NSData>()

  private init() {
    cache.countLimit = 0
    cache.totalCostLimit = 0
    
  }
  
  func getImage(forKey key: String) -> Data? {
    if let cachedData = cache.object(forKey: key as NSString) {
      return cachedData as Data
    }
    return nil
  }
  
  func setImage(_ image: Data, forKey key: String) {
    cache.setObject(image as NSData, forKey: key as NSString)
  }
}
