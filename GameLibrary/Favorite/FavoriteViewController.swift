//
//  FavoriteViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    
    public var viewModel: FavoriteViewModel?
    
    private var errorLabel: UILabel! = {
        var lbl = UILabel(frame: .zero)
        lbl.text = "There is no favorites found."
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        return lbl
    }()
    
    private lazy var gameTableView: UITableView! = {
        var table = UITableView(frame: .zero)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(GameTableViewCell.self, forCellReuseIdentifier: "GameTableViewCell")
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        errorLabel.isHidden = true
        guard let us = UserDefaults.standard.array(forKey: "fav") else{ return }
        
        if viewModel?.favoriteGames.count != us.count{
            viewModel?.fetchData()
            return
        }else{
            if us.isEmpty{
                errorLabel.isHidden = false
            }
        }
        checkTitle()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        checkTitle()
        

        viewModel = FavoriteViewModel(service: NetworkingService())
        viewModel?.delegate = self
        view.addSubview(gameTableView)
        view.addSubview(errorLabel)
        
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    private func checkTitle() {
        guard let us = UserDefaults.standard.array(forKey: "fav") else{ return }
        if us.count != 0 {
            title = "Favorites(\(us.count))"
            errorLabel.isHidden = true
        }else{
            title = "Favorites"
            errorLabel.isHidden = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        errorLabel.topToSuperview(offset: 48, usingSafeArea: true)
        errorLabel.leadingToSuperview()
        errorLabel.trailingToSuperview()
        errorLabel.height(192)
        
        gameTableView.topToSuperview(offset: 32, usingSafeArea: true)
        gameTableView.leadingToSuperview(offset: 0)
        gameTableView.trailingToSuperview(offset: 0)
        gameTableView.bottomToSuperview(offset: 0, usingSafeArea: true)
    }
    
    private func showAlert(title: String, message: String, indexPath: IndexPath) {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
        }))
        sheet.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: { action in
            guard var favorites = UserDefaults.standard.array(forKey: "fav") as? [String],
                  let model = self.viewModel?.favoriteGames[indexPath.row],
                  let firstIndex = favorites.firstIndex(of: "\(model)") else {return }
            favorites.remove(at:  firstIndex)
            UserDefaults.standard.set(favorites, forKey: "fav")
            self.viewModel?.favoriteGames.remove(at: indexPath.row)
            self.gameTableView.reloadData()
            self.checkTitle()
        }))
        self.present(sheet, animated: true, completion: nil)
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameTableView.deselectRow(at: indexPath, animated: true)
        
        let vc = GameDetailViewController()
        vc.viewModel = GameDetailViewModel()
        vc.viewModel.game = viewModel?.favoriteGames[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        guard let model = viewModel?.favoriteGames[indexPath.row] else {return cell }
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.favoriteGames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.showAlert(title: "Do you confirm?", message: "This game will be removed from your favorites.", indexPath: indexPath)
        }
    }
}

extension FavoriteViewController: FavoriteViewModelDelegate{
    func didFetchCompleted() {
        DispatchQueue.main.async {
            self.gameTableView.reloadData()
            if (self.viewModel?.favoriteGames.isEmpty) ?? false{
                self.errorLabel.isHidden = false
                self.gameTableView.isHidden = true
            }
        }
    }
}


