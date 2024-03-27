//
//  LoadingView.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
import UIKit

class LoadingView {
  
  internal static var spinner: UIActivityIndicatorView?
  
  static func show() {
    DispatchQueue.main.async {
      NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
      if spinner == nil, let window = UIApplication
        .shared
        .connectedScenes
        .flatMap ({ ($0 as? UIWindowScene)?.windows ?? [] })
        .last(where: { $0.isKeyWindow }) {
        let frame = UIScreen.main.bounds
        let spinner = UIActivityIndicatorView(frame: frame)
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        spinner.color = UIColor(named: "ShadowColor")
        spinner.style = .large
        window.addSubview(spinner)
        
        spinner.startAnimating()
        self.spinner = spinner
      }
    }
  }
  
  static func hide() {
    DispatchQueue.main.async {
      guard let spinner = spinner else { return }
      spinner.stopAnimating()
      spinner.removeFromSuperview()
      self.spinner = nil
    }
  }
  
  @objc static func update() {
    DispatchQueue.main.async {
      if spinner != nil {
        hide()
        show()
      }
    }
  }
}
