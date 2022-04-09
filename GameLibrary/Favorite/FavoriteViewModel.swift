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
        self.favoriteGames = []
        
        guard let us = UserDefaults.standard.array(forKey: "fav") else{ return }
        
        if us.count == 0{
            self.delegate?.didFetchCompleted()
            return
        }
        
        let myGroup = DispatchGroup()
        for i in us ?? []{
            myGroup.enter()
            service.getData(Game.self, url: "https://api.rawg.io/api/games/\(i)?key=3be8af6ebf124ffe81d90f514e59856c") { [weak self] result in
                guard let strongSelf = self else { return }
                strongSelf.favoriteGames.append(result)
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: .main){
            self.delegate?.didFetchCompleted()
        }
    }

}
