//
//  FavoriteViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 10.04.2022.
//

import UIKit
import Moya


protocol FavoriteViewModelDelegate: AnyObject {
    func didFetchCompleted()
}

class FavoriteViewModel: NSObject {
    
    public var favoriteGames: [Game] = []
    
    weak var delegate: FavoriteViewModelDelegate?
        
    public var gameProvider = MoyaProvider<MoyaService>()
    
    
    func fetchData() {
        self.favoriteGames = []
        
        guard let favoriteGameIds = UserDefaults.standard.array(forKey: "fav") else{return }
        
        if favoriteGameIds.isEmpty{
            self.delegate?.didFetchCompleted()
            return
        }
        
        let myGroup = DispatchGroup()
        for id in favoriteGameIds {
            myGroup.enter()
            gameProvider.request(.getDetail(id: "\(id)")) { [weak self] result in
                switch result {
                    case .success(let response):
                        do{
                            let object = try JSONDecoder().decode(Game.self, from: response.data)
                            guard let strongSelf = self else {return }
                            strongSelf.favoriteGames.append(object)
                            myGroup.leave()
                        }catch{
                            print("Function: \(#function), line: \(#line)")
                            myGroup.leave()
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
        
        myGroup.notify(queue: .main) {
            self.delegate?.didFetchCompleted()
        }
    }

}
