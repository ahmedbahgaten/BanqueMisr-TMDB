//
//  MovieTableViewCell.swift
//  BanqueMisr-TMDB
//
//  Created by Ahmed Bahgat on 26/03/2024.
//

import UIKit

//@MainActor
class MovieTableViewCell: UITableViewCell {
  //MARK: - Properties
  static let reuseIdentifier = String(describing: MovieTableViewCell.self)
  private var fetchImageRepository: FetchImageRepository?
  private var imageDownloadTask: Task<Data?, Error>?
  //MARK: - Outlets
  @IBOutlet private weak var moviePosterImgView: UIImageView!
  @IBOutlet private weak var movieTitleLbl: UILabel!
  @IBOutlet private weak var releaseDateTitleLbl: UILabel!
  @IBOutlet private weak var containerView: UIView!
    //MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    dropShadowForContainerView()
    setupImgView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageDownloadTask?.cancel()
  }
  
  //MARK: - Methods
  func setupCell(listItem:MovieListItemViewModel,
                 fetchImageRepo:FetchImageRepository) {
    self.fetchImageRepository = fetchImageRepo
    self.movieTitleLbl.text = listItem.title
    self.releaseDateTitleLbl.text = listItem.releaseDate
    guard let posterImgPath = listItem.posterImagePath else {
      moviePosterImgView.image = UIImage(named: "TMDB")
      return
    }
    setPosterImage(posterPath: posterImgPath,
                   fetchImageRepo:fetchImageRepo)
  }
  
  private func setPosterImage(posterPath:String,
                              fetchImageRepo:FetchImageRepository) {
    if let image = ImageCacheManager.shared.getImage(forKey: posterPath) {
      moviePosterImgView.image = image
    }else {
      imageDownloadTask = Task { [weak self] in
        guard let self = self else {return nil }
        do {
          let imgWidth = Int(moviePosterImgView.frame.size.width)
          let imageData = try await fetchImageRepo.fetchImage(with: posterPath,
                                                              width:imgWidth)
          if let img = UIImage(data: imageData) {
            moviePosterImgView.image = img
            ImageCacheManager.shared.setImage(img, forKey: posterPath)
          }else {
            moviePosterImgView.image = UIImage(named: "TMDB")
          }
          return imageData
        }catch {
          moviePosterImgView.image = UIImage(named: "TMDB")
          return nil
        }
      }
    }
  }
  
  private func dropShadowForContainerView() {
    containerView.layer.cornerRadius = 8
    containerView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
    containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    containerView.layer.shadowOpacity = 0.2
    containerView.layer.shadowRadius = 4
    containerView.layer.masksToBounds = false
  }
  
  private func setupImgView() {
    moviePosterImgView.layer.cornerRadius = 8
  }
}
