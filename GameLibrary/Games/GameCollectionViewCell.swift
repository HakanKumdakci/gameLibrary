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
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var nameOfGame: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir-Roman", size: 18)
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
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
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
        
        let userImageViewHeight: CGFloat = 100
        let userImageViewWidth: CGFloat = 144
        
        imageOfGame.topToSuperview(offset: 0)
        imageOfGame.leadingToSuperview(offset: 12)
        imageOfGame.height(userImageViewHeight)
        imageOfGame.width(userImageViewWidth)
        
        nameOfGame.topToSuperview(offset: 0)
        nameOfGame.leadingToTrailing(of: imageOfGame, offset: 12)
        nameOfGame.trailingToSuperview()
        nameOfGame.height(54)
        
        genre.bottom(to: imageOfGame, offset: -6)
        genre.leadingToTrailing(of: imageOfGame, offset: 12)
        genre.trailingToSuperview(offset: 12)
        genre.height(18)
        
        metaCritic.bottomToTop(of: genre, offset: -6)
        metaCritic.leadingToTrailing(of: imageOfGame, offset: 12)
        metaCritic.trailingToSuperview()
        metaCritic.height(18)
        
        self.layer.cornerRadius = 4
        self.imageOfGame.backgroundColor = UIColor(hex: "000000", alpha: 0.8)
    }
    
    
    public func configure(with model: Game) {
        self.model = model
        nameOfGame.text = model.name
        
        // check genres and place them to string
        if model.genres.count > 0{
            var str = ""
            var strArr: [String] = []
            
            strArr = model.genres.compactMap({ $0.name })
            str = strArr.joined(separator: ", ")
            
            genre.text = str
        }
        //check the url and get image
        if let imgUrl = model.background_image,
           let url = URL(string: imgUrl) {
            if imgUrl != ""{
                self.imageOfGame.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad])
            }
            
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: "metacritic: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]));
            text.append(NSAttributedString(string: "\(model.metacritic ?? 0)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "D80000", alpha: 1.0), NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18.0)!] ))
            self.metaCritic.attributedText = text
        }
        
        if let tapped = UserDefaults.standard.array(forKey: "tapped") as? [String] {
            self.backgroundColor = tapped.contains("\(model.id)") ? UIColor(hex: "E0E0E0", alpha: 1.0) : .white
        }
        
        
    }
    
    
    
    
}
