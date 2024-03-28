//
//  NibInstantiable.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
import UIKit

public protocol NibInstantiatable {
  
  static func nibName() -> String
  
}

extension NibInstantiatable {
  
  static func nibName() -> String {
    return String(describing: self)
  }
  
}

extension NibInstantiatable where Self: UIView {
  
  static func fromNib() -> Self {
    
    let bundle = Bundle(for: self)
    let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
    
    return nib!.first as! Self
    
  }
  
}
