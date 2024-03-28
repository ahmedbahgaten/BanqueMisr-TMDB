//
//  Extension + UIViewController.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 27/03/2024.
//

import Foundation
import UIKit
extension UIViewController {
  @discardableResult
  func addChildVC<T: UIViewController>(_ child: T, into container: UIView) -> T {
    addChild(child)
    container.addSubview(child.view)
    child.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      child.view.topAnchor.constraint(equalTo: container.topAnchor),
      child.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      child.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      child.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])
    child.didMove(toParent: self)
    return child
  }
  
  func showLoader() {
    let loaderView = LoaderView.fromNib()
    self.view.addSubview(loaderView)
    loaderView.tag = 100
    loaderView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
    loaderView.topAnchor.constraint(equalTo: view.topAnchor),
    loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    ])
    loaderView.show()
  }
  
  func hideLoader() {
    if let view = self.view.viewWithTag(100) as? LoaderView {
      view.hide()
      view.removeFromSuperview()
    }
  }
}
