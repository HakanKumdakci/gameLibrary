//
//  GamesViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit

import TinyConstraints

class GamesViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        //searchResultViewController.viewModel.search(str: text)
        //viewModel?.search(str: text)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.count < 3{
            return
        }
        
        searchResultViewController.viewModel.search(str: text, page: 1)
        searchResultViewController.viewModel.searchText = text
        errorLabel.isHidden = true
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        if text.count == 0{
            gameCollectionView.isHidden = true
            errorLabel.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        errorLabel.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        gameCollectionView.isHidden = false
        errorLabel.isHidden = true
    }
    
    
    
    
    var viewModel: GamesViewModel?
    
    var searchResultViewController : SearchResultViewController!
    
    var errorLabel: UILabel! = {
        var lbl = UILabel(frame: .zero)
        lbl.text = "No game has been searched."
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        return lbl
    }()
    
    
    lazy var searchController: UISearchController = {
        searchResultViewController = SearchResultViewController()
        var searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel?.gameApi == nil{
            viewModel!.fetchData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        UserDefaults.standard.set([], forKey: "tapped")
        
        
        viewModel = GamesViewModel(service: NetworkingService.shared)
        viewModel?.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(gameCollectionView)
        view.addSubview(errorLabel)
        
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        errorLabel.topToSuperview(offset: 48, usingSafeArea: true)
        errorLabel.leadingToSuperview()
        errorLabel.trailingToSuperview()
        errorLabel.height(192)
        
        gameCollectionView.topToSuperview(offset: 32, usingSafeArea: true)
        gameCollectionView.leadingToSuperview(offset: 0)
        gameCollectionView.trailingToSuperview(offset: 0)
        gameCollectionView.bottomToSuperview(offset: 0, usingSafeArea: true)
        
    }
    
}
extension GamesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = GameDetailViewController()
        vc.viewModel = GameDetailViewModel(service: NetworkingService.shared)
        vc.viewModel.game = viewModel?.gameApi?.results[indexPath.row]
        
        var us = UserDefaults.standard.array(forKey: "tapped") as! [String]
        if us.contains("\(viewModel?.gameApi?.results[indexPath.row].id ?? 0)"){
            
        }else{
            us.append("\(viewModel?.gameApi?.results[indexPath.row].id ?? 0)")
            UserDefaults.standard.set(us, forKey: "tapped")
            gameCollectionView.reloadItems(at: [indexPath])
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        let model = (viewModel?.gameApi?.results[indexPath.row])!
        cell.configure(with: model)
        
        let us = UserDefaults.standard.array(forKey: "tapped") as! [String]
        if us.contains("\(model.id)"){
            cell.backgroundColor = .gray
        }else{
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.gameApi?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
}


extension GamesViewController: GamesViewModelDelegate{
    func didSearchComplete() {
        print()
    }
    
    func didFetchCompleted() {
        DispatchQueue.main.async {
            self.gameCollectionView.reloadData()
        }
    }
    
}
