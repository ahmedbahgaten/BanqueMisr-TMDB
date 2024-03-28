//
//  LoaderView.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import UIKit

class LoaderView: UIView,NibInstantiatable {

  @IBOutlet private weak var loader: UIActivityIndicatorView!
  @IBOutlet private weak var containerView: UIView!
  
  //MARK: - Methods
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 8
  }
  
  func show() {
    loader.startAnimating()
  }
  
  func hide() {
    loader.stopAnimating()
    removeFromSuperview()
  }
}
