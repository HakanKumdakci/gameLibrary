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
        guard let key = Bundle.main.object(forInfoDictionaryKey: "privateKey") as? String else{ return }
        guard let api = Bundle.main.object(forInfoDictionaryKey: "gameDetail") as? String else{ return }
        
        service.getData(GameDetail.self, url: "\(api)\(game.id)?key=\(key)") { [weak self] result in
            guard let strongSelf = self else {return }
            strongSelf.gameDetail = result
            strongSelf.delegate?.didFetchCompleted()
        }
    }
}
