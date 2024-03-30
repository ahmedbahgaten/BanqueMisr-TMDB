//
//  Extension + Error.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 28/03/2024.
//

import Foundation
extension Error {
  var errorMessage:String {
    if let error = self as? NetworkError {
      return error.errorMessage
    }else if let error = self as? DataTransferError {
      return error.errorMessage
    }else if let error = self as? APIError {
      return error.statusMessage
    }else {
      return "Something went wrong"
    }
  }
}
