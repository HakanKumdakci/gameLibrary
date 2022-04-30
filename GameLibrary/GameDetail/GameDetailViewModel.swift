//
//  GameDetailViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit
import Moya


protocol GameDetailViewModelDelegate: AnyObject{
    func didFetchCompleted()
}

class GameDetailViewModel: NSObject {

    var game: Game!
    weak var delegate: GameDetailViewModelDelegate?
    var gameDetail: GameDetail!
    var service: NetworkingServiceProtocol!
    
    var gameProvider = MoyaProvider<MoyaService>()
    
    init(service: NetworkingServiceProtocol) {
        self.service = service
    }
    
    func fetchData(){
        
        gameProvider.request(.getDetail(id: "\(game.id)")) { [weak self] result in
            switch result{
                case .success(let response):
                    let object = try! JSONDecoder().decode(GameDetail.self, from: response.data)
                    guard let strongSelf = self else {return }
                    strongSelf.gameDetail = object
                    strongSelf.delegate?.didFetchCompleted()
                case .failure(let error):
                    print(error)
            }
        }
    }
}
