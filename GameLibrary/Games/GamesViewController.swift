//
//  GamesViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit

import TinyConstraints

class GamesViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else {return }
        
        UserDefaults.standard.set(true, forKey: "searched")
        
        if let searchKey = UserDefaults.standard.string(forKey: "key"){
            if searchKey == text{
                searchResultViewController.viewModel.searchText = text
                searchResultViewController.viewModel.fetchFromRealm()
                errorLabel.isHidden = true
                return
            }
        }
        
        if text.count <= 3{
            UserDefaults.standard.set(nil, forKey: "key")
            return
        }
        
        searchResultViewController.viewModel.fetchData(str: text)
        searchResultViewController.viewModel.searchText = text
        errorLabel.isHidden = true
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else {return }
        
        //fetch latest search screen
        if let searchKey = UserDefaults.standard.string(forKey: "key"){
            if searchKey != ""{
                if text == ""{
                    searchController.searchBar.text = searchKey
                    searchController.searchBar.endEditing(true)
                }else{
                    
                }
            }
        }
        //first search screen
        if text.count == 0{
            gameCollectionView.isHidden = true
            errorLabel.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            searchResultViewController.viewModel.searchedGameApi = nil
            searchResultViewController.gameCollectionView.reloadData()
            errorLabel.isHidden = false
        }else{
            errorLabel.isHidden = true
        }
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        gameCollectionView.isHidden = false
        errorLabel.isHidden = true
        UserDefaults.standard.set(false, forKey: "searched")
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
        var searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Games"
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
    
    lazy var nextButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.backgroundColor = .clear
        btn.tintColor = .systemBlue
        btn.tag = 2
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
        btn.addTarget(self, action: #selector(getNewPage(sender:)), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    lazy var prevButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("Previous", for: .normal)
        btn.backgroundColor = .clear
        btn.tintColor = .systemBlue
        btn.tag = 1
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
        btn.addTarget(self, action: #selector(getNewPage(sender:)), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel?.gameApi == nil{
            viewModel!.fetchData()
        }
        
        if UserDefaults.standard.bool(forKey: "searched"){
            searchController.searchBar.becomeFirstResponder()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        UserDefaults.standard.set([], forKey: "tapped")
        
        searchResultViewController = SearchResultViewController()
        searchResultViewController.delegate = self
        
        
        viewModel = GamesViewModel(service: NetworkingService.shared)
        viewModel?.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(gameCollectionView)
        view.addSubview(errorLabel)
        
        errorLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        gameCollectionView.reloadData()
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
        gameCollectionView.bottomToSuperview(offset: -36, usingSafeArea: true)
    }
    
    @objc func getNewPage(sender: UIButton){
        self.gameCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        if sender.tag == 1{
            viewModel?.fetchData(optionalURL: "\(viewModel?.gameApi?.previous ?? "")")
        }else{
            viewModel?.fetchData(optionalURL: "\(viewModel?.gameApi?.next ?? "")")
        }
    }
    
}
extension GamesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //if user touch on button cell
        if indexPath.row == viewModel?.gameApi?.results.count{
            return
        }
        //prepare view to push
        let vc = GameDetailViewController()
        vc.viewModel = GameDetailViewModel(service: NetworkingService.shared)
        vc.viewModel.game = viewModel?.gameApi?.results[indexPath.row]
        
        //make gray when pressed on game cell
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
        if indexPath.row == viewModel?.gameApi?.results.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.addSubview(prevButton)
            cell.addSubview(nextButton)
            prevButton.leadingToSuperview(offset: 16)
            prevButton.centerYToSuperview()
            prevButton.height(36)
            prevButton.width(96)
            
            nextButton.trailingToSuperview(offset: 16)
            nextButton.centerYToSuperview()
            nextButton.height(36)
            nextButton.width(96)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        let model = (viewModel?.gameApi?.results[indexPath.row])!
        cell.configure(with: model)
        
        let us = UserDefaults.standard.array(forKey: "tapped") as! [String]
        if us.contains("\(model.id)"){
            cell.backgroundColor = Helper.shared.hexStringToUIColor(hex: "E0E0E0", alpha: 1.0)
        }else{
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.gameApi?.results.count ?? -1) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = indexPath.row == viewModel?.gameApi?.results.count ? 40.0 : 100.0
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: self.view.frame.width/2.1, height: height)
        } else {
            return CGSize(width: self.view.frame.width, height: height)
        }
        
    }
}


extension GamesViewController: GamesViewModelDelegate{
    func didSearchComplete() {
        print()
    }
    
    func didFetchCompleted() {
        DispatchQueue.main.async {
            self.gameCollectionView.reloadData()
            self.nextButton.isEnabled =  self.viewModel?.gameApi?.next == nil ? false : true
            self.prevButton.isEnabled =  self.viewModel?.gameApi?.previous == nil ? false : true
        }
    }
    
}


extension GamesViewController: SearchResultViewControllerDelegate{
    func openDetail(vc: GameDetailViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
