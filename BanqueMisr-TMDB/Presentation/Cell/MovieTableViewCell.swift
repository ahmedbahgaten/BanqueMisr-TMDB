//
//  MovieTableViewCell.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
  //MARK: - Properties
  static let reuseIdentifier = String(describing: MovieTableViewCell.self)
  //MARK: - Outlets
  @IBOutlet weak var moviePosterImgView: UIImageView!
  @IBOutlet weak var movieTitleLbl: UILabel!
  @IBOutlet weak var releaseDateTitleLbl: UILabel!
  //MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupCell(listItem:MovieListItemViewModel) {
    self.movieTitleLbl.text = listItem.title
    self.releaseDateTitleLbl.text = listItem.releaseDate
  }
}
