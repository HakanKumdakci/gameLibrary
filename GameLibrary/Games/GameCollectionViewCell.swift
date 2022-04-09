//
//  GameCollectionViewCell.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit
import SDWebImage


class GameCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GameCollectionViewCell"
    var model: Game?
    
    
    
    let imageOfGame: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 0
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.contentMode = .center
        return imageView
    }()
    
    var nameOfGame: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir-Roman", size: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    var metaCritic: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir-Roman", size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    var genre: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir-Roman", size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(imageOfGame)
        contentView.addSubview(nameOfGame)
        contentView.addSubview(metaCritic)
        contentView.addSubview(genre)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let userImageViewHeight: CGFloat = 154
        let userImageViewWidth: CGFloat = 144
        
        imageOfGame.topToSuperview(offset: 12)
        imageOfGame.leadingToSuperview(offset: 12)
        imageOfGame.height(userImageViewHeight)
        imageOfGame.width(userImageViewWidth)
        
        nameOfGame.topToSuperview(offset: 12)
        nameOfGame.leadingToTrailing(of: imageOfGame, offset: 12)
        nameOfGame.trailingToSuperview()
        nameOfGame.height(48)
        
        genre.bottom(to: imageOfGame)
        genre.leadingToTrailing(of: imageOfGame, offset: 12)
        genre.trailingToSuperview(offset: 12)
        genre.height(24)
        
        metaCritic.bottomToTop(of: genre, offset: -12)
        metaCritic.leadingToTrailing(of: imageOfGame, offset: 12)
        metaCritic.trailingToSuperview()
        metaCritic.height(24)
        
        self.layer.cornerRadius = 4
        self.imageOfGame.backgroundColor = Helper.shared.hexStringToUIColor(hex: "000000", alpha: 0.8)
        
    }
    
    
    public func configure(with model: Game){
        self.model = model
        nameOfGame.text = model.name
        
        if model.genres.count > 0{
            genre.text = ""
            for i in 0..<model.genres.count-1{
                genre.text! += "\(model.genres[i].name), "
            }
            genre.text! += "\(model.genres[model.genres.count-1].name)"
        }
        
        if let imgUrl = model.background_image{
            let url = URL(string: imgUrl)!
            self.imageOfGame.downloadImage(from: url, width: 144, height: 154)
            self.metaCritic.text = "metacritic: \(model.metacritic ?? 0)"
        }
        
        
    }
    
    
    
    
}
