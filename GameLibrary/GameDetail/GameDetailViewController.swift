//
//  GameDetailViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit
import SafariServices
import TinyConstraints
import SDWebImage

class GameDetailViewController: UIViewController {
    
    var viewModel: GameDetailViewModel!
    private var expandedDetail = false
    
    private let imageOfGame: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 0
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var nameOfGame: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir-Heavy", size: 28)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    private var titleOfDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir-Roman", size: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    private var detailOfGame: UITextView = {
        var textView = UITextView(frame: .zero)
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.font = UIFont(name: "Avenir-Roman", size: 15)
        return textView
    }()
    
    private lazy var redditButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("", for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.backgroundColor = .clear
        btn.tintColor = .black
        btn.tag = 1
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 21)
        btn.addTarget(self, action: #selector(openSafari(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var websitebutton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("", for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.backgroundColor = .clear
        btn.tintColor = .black
        btn.tag = 2
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 21)
        btn.addTarget(self, action: #selector(openSafari(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var detailTableView: UITableView! = {
        var table = UITableView(frame: .zero)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        if let favGames = UserDefaults.standard.value(forKey: "fav") as? [String]{
            if favGames.contains(where: { $0 == "\(viewModel.game.id)"} ) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "UnFavorite", style: .done, target: self, action: #selector(self.toggleFavorite))
            }else{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Favorite", style: .done, target: self, action: #selector(self.toggleFavorite))
            }
        }else{
            UserDefaults.standard.set([], forKey: "fav")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Favorite", style: .done, target: self, action: #selector(self.toggleFavorite))
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.websitebutton.isEnabled = false
        self.redditButton.isEnabled = false
        
        view.addSubview(imageOfGame)
        imageOfGame.addSubview(nameOfGame)
        
        view.addSubview(detailTableView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        detailOfGame.addGestureRecognizer(tapGestureRecognizer)
        detailOfGame.textContainer.maximumNumberOfLines = 4
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        if sender.view == detailOfGame{
            if !expandedDetail{
                DispatchQueue.main.async {
                    self.detailOfGame.textContainer.maximumNumberOfLines = 0
                    self.expandedDetail.toggle()
                    self.detailOfGame.invalidateIntrinsicContentSize()
                }
            }else{
                DispatchQueue.main.async {
                    self.detailOfGame.textContainer.maximumNumberOfLines = 4
                    self.expandedDetail.toggle()
                    self.detailOfGame.invalidateIntrinsicContentSize()
                }
            }
            detailTableView.reloadData()
        }
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
        
        detailTableView.topToBottom(of: imageOfGame, offset: 16)
        detailTableView.leadingToSuperview(offset: 16)
        detailTableView.trailingToSuperview(offset: 16)
        detailTableView.bottomToSuperview(offset: 0, usingSafeArea: true)
        
    }
    
    @objc private func openSafari(sender: UIButton) {
        guard var url = URL(string: "\(self.viewModel.gameDetail.reddit_url ?? "")") else {return }
        
        if sender.tag == 2{
            guard let url2 = URL(string: "\(self.viewModel.gameDetail.website ?? "")") else {return }
            url = url2
        }
        let vc = SFSafariViewController(url: url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc private func toggleFavorite() {
        if var favGames = UserDefaults.standard.value(forKey: "fav") as? [String] {
            if let index = favGames.firstIndex(of: "\(viewModel.game.id)") {
                favGames.remove(at: index)
                UserDefaults.standard.set(favGames, forKey: "fav")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Favorite", style: .done, target: self, action: #selector(self.toggleFavorite))
            }else{
                favGames.append("\(viewModel.game.id)")
                UserDefaults.standard.set(favGames, forKey: "fav")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "UnFavorite", style: .done, target: self, action: #selector(self.toggleFavorite))
            }
        }
    }
    
}

extension GameDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.addSubview(titleOfDescription)
            cell.addSubview(detailOfGame)

            titleOfDescription.topToSuperview()
            titleOfDescription.leadingToSuperview(offset: 16)
            titleOfDescription.trailingToSuperview(offset: 16)
            titleOfDescription.height(36)

            detailOfGame.topToBottom(of: titleOfDescription)
            detailOfGame.leading(to: titleOfDescription)
            detailOfGame.trailing(to: titleOfDescription)
            detailOfGame.bottomToSuperview()
            
        }else if indexPath.row == 1 {
            cell.addSubview(redditButton)
            
            redditButton.topToSuperview()
            redditButton.leadingToSuperview(offset: 32)
            redditButton.width(128)
            redditButton.bottomToSuperview()
        }else if indexPath.row == 2 {
            cell.addSubview(websitebutton)
            
            websitebutton.topToSuperview()
            websitebutton.leadingToSuperview(offset: 32)
            websitebutton.width(128)
            websitebutton.bottomToSuperview()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? (expandedDetail ? self.view.frame.height/1.6 : self.view.frame.height/6) : 48
    }
    
}


extension GameDetailViewController: GameDetailViewModelDelegate{
    func didFetchCompleted() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.websitebutton.isEnabled = true
            self.redditButton.isEnabled = true
            
            self.titleOfDescription.text = "Game Description"
            self.redditButton.setTitle("Visit reddit", for: .normal)
            self.websitebutton.setTitle("Visit website", for: .normal)
            
            self.detailOfGame.text = self.viewModel.gameDetail.description
            self.nameOfGame.text = self.viewModel.gameDetail.name
            self.detailTableView.reloadData()
            
            self.imageOfGame.backgroundColor = UIColor(hex: "000000", alpha: 0.8)
            guard let url = URL(string: "\(self.viewModel.gameDetail.background_image)") else {return }
            let transition = SDWebImageTransition.fade
            
            transition.animations = { (view, image) in
                view.transform = .identity
            }
            self.imageOfGame.sd_imageTransition = transition
            self.imageOfGame.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad])
            
        }
    }
}
