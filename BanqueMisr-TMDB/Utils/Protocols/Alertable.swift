//
//  Alertable.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
import UIKit

protocol Alertable {}
extension Alertable where Self: UIViewController {
  
  func showAlert(
    title: String = "",
    message: String,
    preferredStyle: UIAlertController.Style = .alert,
    completion: (() -> Void)? = nil
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: completion)
  }
}
