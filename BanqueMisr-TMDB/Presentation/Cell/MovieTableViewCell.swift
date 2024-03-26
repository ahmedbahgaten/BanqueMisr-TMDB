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
  @IBOutlet private weak var moviePosterImgView: UIImageView!
  @IBOutlet private weak var movieTitleLbl: UILabel!
  @IBOutlet private weak var releaseDateTitleLbl: UILabel!
  @IBOutlet private weak var containerView: UIView!
    //MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    dropShadowForContainerView()
  }
  
  func setupCell(listItem:MovieListItemViewModel) {
    self.movieTitleLbl.text = listItem.title
    self.releaseDateTitleLbl.text = listItem.releaseDate
  }
  
  private func dropShadowForContainerView() {
    containerView.layer.cornerRadius = 8
    containerView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
    containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    containerView.layer.shadowOpacity = 0.2
    containerView.layer.shadowRadius = 4
    containerView.layer.masksToBounds = false
  }
}
