//
//  GamesViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit

protocol GamesViewModelDelegate: AnyObject{
    func didFetchCompleted()
}


class GamesViewModel: NSObject {
    
    var gameApi: GameApi?
    
    weak var delegate: GamesViewModelDelegate?
    
    var service: NetworkingServiceProtocol!
    
    init(service: NetworkingServiceProtocol) {
        self.service = service
    }
    
    
    func fetchData(optionalURL: String = ""){
        let url = (optionalURL == "") ? "https://api.rawg.io/api/games?page_size=10&page=1&key=3be8af6ebf124ffe81d90f514e59856c" : optionalURL
        service.getData(GameApi.self, url: url) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.gameApi = result
            strongSelf.delegate?.didFetchCompleted()
        }
    }
    
}
