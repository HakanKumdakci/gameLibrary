//
//  GameDetailViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit
import SafariServices

class GameDetailViewController: UIViewController {
    
    var viewModel: GameDetailViewModel!
    
    
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
        label.font = UIFont(name: "Avenir-Heavy", size: 28)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    var titleOfDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir-Roman", size: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Game Description"
        return label
    }()
    
    var detailOfGame: UITextView = {
        var ss = UITextView(frame: .zero)
        ss.isScrollEnabled = false
        ss.isSelectable = false
        ss.isEditable = false
        ss.textContainer.maximumNumberOfLines = 4
        ss.isUserInteractionEnabled = true
        ss.textContainer.lineBreakMode = .byTruncatingTail
        ss.font = UIFont(name: "Avenir-Roman", size: 19)
        return ss
    }()
    
    lazy var redditButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("Visit reddit", for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.backgroundColor = .clear
        btn.tintColor = .black
        btn.tag = 1
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 21)
        btn.addTarget(self, action: #selector(openSafari(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var websitebutton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("Visit website", for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.backgroundColor = .clear
        btn.tintColor = .black
        btn.tag = 2
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 21)
        btn.addTarget(self, action: #selector(openSafari(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        viewModel.delegate = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController!.navigationItem.largeTitleDisplayMode = .never
        
        if let ss = UserDefaults.standard.value(forKey: "fav") as? [String]{
            if ss.contains(where: { $0 == "\(viewModel.game.id)"} ) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "UnFavorite", style: .done, target: self, action: #selector(self.toggleFavorite))
            }else{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Favorite", style: .done, target: self, action: #selector(self.toggleFavorite))
            }
        }else{
            UserDefaults.standard.set([], forKey: "fav")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Favorite", style: .done, target: self, action: #selector(self.toggleFavorite))
        }
        
        view.addSubview(imageOfGame)
        imageOfGame.addSubview(nameOfGame)
        view.addSubview(titleOfDescription)
        view.addSubview(detailOfGame)
        view.addSubview(redditButton)
        view.addSubview(websitebutton)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        imageOfGame.topToSuperview(offset: 0, usingSafeArea: true)
        imageOfGame.leadingToSuperview()
        imageOfGame.trailingToSuperview()
        imageOfGame.height(self.view.frame.height/3.5)
        
        nameOfGame.bottomToSuperview(offset: -16)
        nameOfGame.leadingToSuperview(offset: 16)
        nameOfGame.trailingToSuperview(offset: 16)
        nameOfGame.height(36)
        
        titleOfDescription.topToBottom(of: imageOfGame, offset: 16)
        titleOfDescription.leadingToSuperview(offset: 16)
        titleOfDescription.trailingToSuperview(offset: 16)
        titleOfDescription.height(36)
        
        detailOfGame.topToBottom(of: titleOfDescription, offset: 12)
        detailOfGame.leading(to: titleOfDescription)
        detailOfGame.trailing(to: titleOfDescription)
        detailOfGame.height(self.view.frame.height/4)
        
        redditButton.topToBottom(of: detailOfGame, offset: 6)
        redditButton.leadingToSuperview(offset: 32)
        redditButton.trailingToSuperview(offset: 32)
        redditButton.height(48)
        
        websitebutton.topToBottom(of: redditButton, offset: 18)
        websitebutton.leadingToSuperview(offset: 32)
        websitebutton.trailingToSuperview(offset: 32)
        websitebutton.height(48)
        
    }
    
    @objc func openSafari(sender: UIButton){
        var url = URL(string: "\(self.viewModel.gameDetail.reddit_url ?? "")")!
        if sender.tag == 2{
            url = URL(string: "\(self.viewModel.gameDetail.website ?? "")")!
        }
        
        let vc = SFSafariViewController(url: url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func toggleFavorite(){
        
        if var ss = UserDefaults.standard.value(forKey: "fav") as? [String]{
            if let index = ss.firstIndex(of: "\(viewModel.game.id)"){
                ss.remove(at: index)
                UserDefaults.standard.set(ss, forKey: "fav")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Favorite", style: .done, target: self, action: #selector(self.toggleFavorite))
            }else{
                ss.append("\(viewModel.game.id)")
                UserDefaults.standard.set(ss, forKey: "fav")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "UnFavorite", style: .done, target: self, action: #selector(self.toggleFavorite))
            }
        }
        
    }
    
    @objc func seeMoreLess(){
        
    }
}
extension GameDetailViewController: GameDetailViewModelDelegate{
    func didFetchCompleted() {
        let url = URL(string: "\(self.viewModel.gameDetail.background_image)")!
        imageOfGame.downloadImage(from: url, width: self.view.frame.width, height: self.view.frame.height/3.5)
        
        detailOfGame.text = self.viewModel.gameDetail.description
        nameOfGame.text = self.viewModel.gameDetail.name
    }
}
