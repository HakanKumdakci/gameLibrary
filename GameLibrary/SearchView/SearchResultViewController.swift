//
//  SearchResultViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit
import TinyConstraints

protocol SearchResultViewControllerDelegate: AnyObject{
    func openDetail(vc: GameDetailViewController)
}

class SearchResultViewController: UIViewController {
    
    weak var delegate: SearchResultViewControllerDelegate?
    
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
    
    var viewModel: SearchResultViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(gameCollectionView)
        view.addSubview(errorLabel)
        
        gameCollectionView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
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
        gameCollectionView.leadingToSuperview()
        gameCollectionView.trailingToSuperview()
        gameCollectionView.bottomToSuperview(offset: 0, usingSafeArea: true)
    }
    
    @objc func getNewPage(sender: UIButton){
        self.gameCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        if sender.tag == 1{
            viewModel.fetchData(str: viewModel.searchText, optionalURL: viewModel.searchedGameApi?.previous ?? "")
        }else{
            viewModel.fetchData(str: viewModel.searchText, optionalURL: viewModel.searchedGameApi?.next ?? "")
        }
    }
    
}

extension SearchResultViewController: SearchResultViewModelDelegate{
    func didSearchComplete() {
        guard let result = self.viewModel.searchedGameApi?.results else{return }
        
        DispatchQueue.main.async {
            if result.isEmpty{
                self.errorLabel.isHidden = false
                self.gameCollectionView.isHidden = true
                self.errorLabel.text = "Could not found any game according to your search."
            }else{
                self.gameCollectionView.isHidden = false
                self.errorLabel.isHidden = true
                self.gameCollectionView.reloadData()
                self.nextButton.isEnabled =  self.viewModel?.searchedGameApi?.next == nil ? false : true
                self.prevButton.isEnabled =  self.viewModel?.searchedGameApi?.previous == nil ? false : true
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.row == viewModel?.searchedGameApi?.results.count{
            return
        }
        
        let vc = GameDetailViewController()
        vc.viewModel = GameDetailViewModel(service: NetworkingService())
        vc.viewModel.game = viewModel?.searchedGameApi?.results[indexPath.row]
        self.delegate?.openDetail(vc: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == viewModel?.searchedGameApi?.results.count{
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
        
        guard let model = (viewModel?.searchedGameApi?.results[indexPath.row]) else{return cell}
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.searchedGameApi?.results.count ?? -1) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = indexPath.row == viewModel?.searchedGameApi?.results.count ? 40.0 : 100.0
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: self.view.frame.width/2.1, height: height)
        } else {
            return CGSize(width: self.view.frame.width, height: height)
        }
    }
}


