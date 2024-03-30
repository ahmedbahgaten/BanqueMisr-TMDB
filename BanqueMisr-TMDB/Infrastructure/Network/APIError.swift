//
//  APIError.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 30/03/2024.
//

import Foundation

struct APIError:Error,Decodable {
  let statusCode:Int
  let statusMessage:String
  let success:Bool
  
  enum CodingKeys:String,CodingKey {
    case statusCode = "status_code"
    case statusMessage = "status_message"
    case success
  }
}
