//
//  FavoriteViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 10.04.2022.
//

import UIKit

protocol FavoriteViewModelDelegate: AnyObject{
    func didFetchCompleted()
}

class FavoriteViewModel: NSObject {
    
    var favoriteGames: [Game] = []
    
    weak var delegate: FavoriteViewModelDelegate?
    
    var service: NetworkingServiceProtocol!
    
    init(service: NetworkingServiceProtocol) {
        self.service = service
        
    }
    
    func fetchData(){
        guard let key = Bundle.main.object(forInfoDictionaryKey: "privateKey") as? String else{ return }
        guard let api = Bundle.main.object(forInfoDictionaryKey: "gameDetail") as? String else{ return }
        
        self.favoriteGames = []
        
        guard let favoriteGameIds = UserDefaults.standard.array(forKey: "fav") else{return }
        
        if favoriteGameIds.count == 0{
            self.delegate?.didFetchCompleted()
            return
        }
        
        
        let myGroup = DispatchGroup()
        for id in favoriteGameIds {
            myGroup.enter()
            service.getData(Game.self, url: "\(api)\(id)?key=\(key)") { [weak self] result in
                guard let strongSelf = self else {return }
                strongSelf.favoriteGames.append(result)
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: .main){
            self.delegate?.didFetchCompleted()
        }
    }

}
