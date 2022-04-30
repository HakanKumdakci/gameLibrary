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
        
        if let searchKey = UserDefaults.standard.string(forKey: "key") {
            if searchKey == text{
                searchResultViewModel?.fetchFromRealm()
                errorLabel.isHidden = true
                return
            }
        }
        if text.count <= 3{
            UserDefaults.standard.set(nil, forKey: "key")
            return
        }
        searchResultViewModel?.fetchData(str: text)
        errorLabel.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else {return }
        
        //fetch latest search screen
        if let searchKey = UserDefaults.standard.string(forKey: "key") {
            if searchKey != ""{
                if text == ""{
                    searchController.searchBar.text = searchKey
                    searchController.searchBar.endEditing(true)
                }else{
                    
                }
            }
        }
        //first search screen
        if text.isEmpty{
            gameCollectionView.isHidden = true
            errorLabel.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text == "") {
            searchResultViewModel?.searchedGameApi = nil
            searchResultViewController?.gameCollectionView.reloadData()
            UserDefaults.standard.set(nil, forKey: "key")
        }else{
            errorLabel.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.errorLabel.isHidden = true
        errorLabel.isHidden = true
        self.errorLabel.isHidden = true
        gameCollectionView.isHidden = false
        
        UserDefaults.standard.set(false, forKey: "searched")
    }
    
    private var viewModel: GamesViewModel?
    
    var searchResultViewController : SearchResultViewController?
    var searchResultViewModel: SearchResultViewModel?
    
    private var errorLabel: UILabel! = {
        var lbl = UILabel(frame: .zero)
        lbl.text = "No game has been searched."
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.isHidden = true
        return lbl
    }()
    
    
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Games"
        searchController.delegate = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var gameCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "GameCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var nextButton: UIButton = {
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
    
    private lazy var prevButton: UIButton = {
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
        
        if viewModel?.gameApi == nil {
            viewModel?.fetchData { [weak self] result in
                guard let self = self else{return }
                DispatchQueue.main.async {
                    self.receivedData()
                }
            }
        }
        
        if UserDefaults.standard.bool(forKey: "searched") && UserDefaults.standard.string(forKey: "key") != nil{
            searchController.searchBar.becomeFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Games"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        UserDefaults.standard.set([], forKey: "tapped")
        searchResultViewModel = SearchResultViewModel()
        
        
        searchResultViewController = SearchResultViewController()
        searchResultViewController?.delegate = self
        searchResultViewController?.viewModel = searchResultViewModel
        searchResultViewModel?.delegate = searchResultViewController
        
        viewModel = GamesViewModel()
        
        navigationItem.searchController = searchController
        view.addSubview(gameCollectionView)
        view.addSubview(errorLabel)
        
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
        
        gameCollectionView.topToSuperview(offset: 0, usingSafeArea: true)
        gameCollectionView.leadingToSuperview(offset: 0)
        gameCollectionView.trailingToSuperview(offset: 0)
        gameCollectionView.bottomToSuperview(offset: 0)
    }
    
    @objc func getNewPage(sender: UIButton) {
        self.gameCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        if sender.tag == 1 {
            viewModel?.tappedOnPrevious(completion: { [weak self] _ in
                guard let self = self else{return }
                DispatchQueue.main.async {
                    self.receivedData()
                }
            })
            return
        }
        viewModel?.tappedOnNext(completion: { [weak self] _ in
            guard let self = self else {return }
            DispatchQueue.main.async {
                self.receivedData()
            }
        })
    }
    
    func receivedData() {
        self.gameCollectionView.reloadData()
        self.nextButton.isEnabled =  self.viewModel?.gameApi?.next == nil ? false : true
        self.prevButton.isEnabled =  self.viewModel?.gameApi?.previous == nil ? false : true
    }
    
}
extension GamesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //if user touch on button cell
        if indexPath.row == viewModel?.gameApi?.results.count{
            return
        }
        
        //prepare viewModel of view
        var gameDetailViewModel = GameDetailViewModel()
        gameDetailViewModel.game = viewModel?.gameApi?.results[indexPath.row]
        
        //prepare view to push
        let vc = GameDetailViewController()
        vc.viewModel = gameDetailViewModel
        gameDetailViewModel.delegate = vc
        
        //make gray when pressed on game cell
        viewModel?.refreshTappedList(indexPath: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel?.gameApi?.results.count == indexPath.row {
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
        guard let model = (viewModel?.gameApi?.results[indexPath.row]) else {return cell }
        cell.configure(with: model)
        
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


extension GamesViewController: SearchResultViewControllerDelegate {
    func openDetail(vc: GameDetailViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
