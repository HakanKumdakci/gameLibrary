//
//  GamesViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit
import Moya


class GamesViewModel: NSObject {
    
    var gameApi: GameApi?
        
    var service: NetworkingServiceProtocol!
    
    var gameProvider = MoyaProvider<MoyaService>()
    
    init(service: NetworkingServiceProtocol) {
        self.service = service
    }
    
    func fetchData(optionalURL: String = "", completion: @escaping (Bool) -> Void){
        
        gameProvider.request(.getMain(optionalUrl: optionalURL)) { [weak self] result in
            switch result{
                case .success(let response):
                    do{
                        guard let strongSelf = self else { return }
                        let object = try JSONDecoder().decode(GameApi.self, from: response.data)
                        strongSelf.gameApi = object
                        if !object.results.isEmpty{
                           completion(true)
                        }
                    }catch{
                        print("Function: \(#function), line: \(#line)")
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func tappedOnPrevious(completion: @escaping (Bool) -> Void){
        fetchData(optionalURL: "\(gameApi?.previous ?? "")", completion: completion)
    }
    
    func tappedOnNext(completion: @escaping (Bool) -> Void){
        fetchData(optionalURL: "\(gameApi?.next ?? "")", completion: completion)
    }
    
    
    func refreshTappedList(indexPath: IndexPath){
        var us = UserDefaults.standard.array(forKey: "tapped") as! [String]
        if us.contains("\(gameApi?.results[indexPath.row].id ?? 0)"){
        }else{
            us.append("\(gameApi?.results[indexPath.row].id ?? 0)")
            UserDefaults.standard.set(us, forKey: "tapped")
        }
    }
    
}
