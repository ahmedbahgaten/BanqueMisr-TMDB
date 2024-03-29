//
//  Extension + UITableView.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
import UIKit

//MARK: - ActivityIndicator
extension UITableView {
  func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    activityIndicator.color = UIColor(named: "ShadowColor")
    activityIndicator.startAnimating()
    activityIndicator.isHidden = false
    activityIndicator.frame = .init(origin: .zero, size: size)
    
    return activityIndicator
  }
}
//MARK: - EmptyList
extension UITableView {
  func setEmptyMessage(_ message: String = "Empty list") {
    let label = UILabel()
    label.textAlignment = .center
    label.text = message
    label.textColor = .darkGray
    self.backgroundView = label
  }
  
  func removeEmptyMessage() {
    self.backgroundView = nil
  }
}
