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
  private var cache:[String:Data] = [:]
  
  private init() {}
  
  func getImage(forKey key: String) -> Data? {
    return cache[key]
  }
  
  func setImage(_ image: Data, forKey key: String) {
    cache[key] = image
  }
}
