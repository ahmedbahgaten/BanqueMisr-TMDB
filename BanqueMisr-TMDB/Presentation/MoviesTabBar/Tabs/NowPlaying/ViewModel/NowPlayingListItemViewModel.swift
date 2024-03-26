//
//  NowPlayingListItemViewModel.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
struct NowPlayingListItemViewModel: Equatable {
  let id: String
  let title: String
  let releaseDate: String
  let posterImagePath: String?
}

extension NowPlayingListItemViewModel {
  
  init(movie: Movie) {
    self.id = movie.id
    self.title = movie.title ?? ""
    self.posterImagePath = movie.posterPath
    if let releaseDate = movie.releaseDate {
      self.releaseDate = "\(NSLocalizedString("Release Date", comment: "")): \(dateFormatter.string(from: releaseDate))"
    } else {
      self.releaseDate = NSLocalizedString("To be announced", comment: "")
    }
  }
}

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  return formatter
}()
