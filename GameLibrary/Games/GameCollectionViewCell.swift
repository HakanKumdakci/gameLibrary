//
//  GameCollectionViewCell.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit


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
        
        let userImageViewHeight: CGFloat = 64
        let userImageViewWidth: CGFloat = 64
        
        imageOfGame.topToSuperview(offset: 12)
        imageOfGame.leadingToSuperview(offset: 12)
        imageOfGame.height(userImageViewHeight)
        imageOfGame.width(userImageViewWidth)
        
        
        nameOfGame.topToBottom(of: imageOfGame, offset: 16)
        nameOfGame.leadingToSuperview(offset: 12)
        nameOfGame.trailingToSuperview()
        nameOfGame.height(36)
        
        genre.bottomToSuperview(offset: -12)
        genre.leadingToTrailing(of: imageOfGame, offset: 12)
        genre.trailingToSuperview(offset: 12)
        genre.height(24)
        
        self.layer.cornerRadius = 4
        
    }
    
    
    public func configure(with model: Game, selected: Bool){
        self.model = model
        
        
        
        
    }
    
    
    
    
}
