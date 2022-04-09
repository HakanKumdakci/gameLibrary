//
//  SearchResultViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit
import TinyConstraints

class SearchResultViewController: UIViewController {
    
    lazy var gameCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "GameCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var errorLabel: UILabel! = {
        var lbl = UILabel(frame: .zero)
        lbl.text = "No game has been searched."
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        return lbl
    }()
    var viewModel: GamesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GamesViewModel(service: NetworkingService.shared)
        viewModel.delegate = self
        
        view.addSubview(gameCollectionView)
        view.addSubview(errorLabel)
        
        gameCollectionView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        errorLabel.topToSuperview(offset: 48, usingSafeArea: true)
        errorLabel.leadingToSuperview()
        errorLabel.trailingToSuperview()
        errorLabel.height(192)
        
        gameCollectionView.topToSuperview(offset: 32, usingSafeArea: true)
        gameCollectionView.leadingToSuperview()
        gameCollectionView.trailingToSuperview()
        gameCollectionView.bottomToSuperview(offset: 0, usingSafeArea: true)
    }
    
    
    
}

extension SearchResultViewController: GamesViewModelDelegate{
    func didSearchComplete() {
        DispatchQueue.main.async {
            if self.viewModel?.searchedGameApi?.results.count == 0{
                self.errorLabel.isHidden = false
                self.gameCollectionView.isHidden = true
                self.errorLabel.text = "Could not found any game according to your search."
            }else{
                self.gameCollectionView.reloadData()
                self.gameCollectionView.isHidden = false
                self.errorLabel.isHidden = true
            }
        }
    }
    
    func didFetchCompleted() {
        
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = GameDetailViewController()
        vc.viewModel = GameDetailViewModel(service: NetworkingService.shared)
        vc.viewModel.game = viewModel?.searchedGameApi?.results[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        cell.configure(with: (viewModel?.searchedGameApi?.results[indexPath.row])!)
        
        if indexPath.row % 10 == 0{
            let page = (indexPath.row / 10) + 1
            viewModel.search(str: viewModel.searchText, page: page)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.searchedGameApi?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
}


