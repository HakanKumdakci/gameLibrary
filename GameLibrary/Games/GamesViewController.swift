//
//  GamesViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit

import TinyConstraints

class GamesViewController: UIViewController, UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchResultViewController.viewModel.search(str: text)
        //fviewModel?.search(str: text)
    }
    
    
    var viewModel: GamesViewModel?
    
    var searchResultViewController : SearchResultViewController!
    lazy var searchController: UISearchController = {
        searchResultViewController = SearchResultViewController()
        var searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    lazy var gameCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel!.fetchData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        
        
        viewModel = GamesViewModel(service: NetworkingService.shared)
        viewModel?.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(gameCollectionView)
        // Do any additional setup after loading the view.
    }
    
    @objc func updatedSearch(){
        guard let text = searchController.searchBar.text else { return }
        viewModel?.search(str: text)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gameCollectionView.topToSuperview(offset: 32, usingSafeArea: true)
        gameCollectionView.leadingToSuperview(offset: 0)
        gameCollectionView.trailingToSuperview(offset: 0)
        gameCollectionView.bottomToSuperview(offset: 0, usingSafeArea: true)
        
    }
    
    
    
    

}
extension GamesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.gameApi?.results.count ?? 0
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
