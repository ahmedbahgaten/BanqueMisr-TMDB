//
//  Extension + UITableView.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
import UIKit

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
