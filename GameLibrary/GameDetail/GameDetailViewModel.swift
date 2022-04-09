//
//  GameDetailViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit

protocol GameDetailViewModelDelegate: AnyObject{
    func didFetchCompleted()
}

class GameDetailViewModel: NSObject {

    var game: Game!
    weak var delegate: GameDetailViewModelDelegate?
    var gameDetail: GameDetail!
    var service: NetworkingServiceProtocol!
    
    init(service: NetworkingServiceProtocol) {
        self.service = service
    }
    
    
    func fetchData(){
        service.getData(GameDetail.self, url: "https://api.rawg.io/api/games/\(game.id)?key=3be8af6ebf124ffe81d90f514e59856c") { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.gameDetail = result
            DispatchQueue.main.async {
                strongSelf.delegate?.didFetchCompleted()
            }
            
        }
    }
    
}
