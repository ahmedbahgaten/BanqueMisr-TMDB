//
//  ImageCacheManager.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
import UIKit

class ImageCacheManager {
  static let shared = ImageCacheManager()
  private let cache = NSCache<NSString, UIImage>()
  
  private init() {}
  
  func getImage(forKey key: String) -> UIImage? {
    return cache.object(forKey: key as NSString)
  }
  
  func setImage(_ image: UIImage, forKey key: String) {
    cache.setObject(image, forKey: key as NSString)
  }
}
