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
        guard let api = Bundle.main.object(forInfoDictionaryKey: "baseUrl") as? String else{ return }
                
        let url = (optionalURL == "") ? api : optionalURL
        service.getData(GameApi.self, url: url) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.gameApi = result
            strongSelf.delegate?.didFetchCompleted()
        }
    }
    
}
