//
//  NowPlayingListItemViewModel.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import Foundation
struct MovieListItemViewModel: Equatable,Hashable {
  let id: String
  let title: String
  let releaseDate: String
  let posterImagePath: String?
}

extension MovieListItemViewModel {
  
  init(movie: Movie) {
    self.id = movie.id
    self.title = movie.title ?? ""
    self.posterImagePath = movie.posterPath
    if let releaseDate = movie.releaseDate {
      self.releaseDate = dateFormatter.string(from: releaseDate)
    } else {
      self.releaseDate = "To be announced"
    }
  }
}

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  return formatter
}()
