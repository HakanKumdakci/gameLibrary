//
//  SearchResultViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit
import RealmSwift
import Moya

protocol SearchResultViewModelDelegate: AnyObject{
    func didSearchComplete()
}

class SearchResultViewModel: NSObject {
    
    var searchText: String = ""
    var searchedGameApi: GameApi?
    weak var delegate: SearchResultViewModelDelegate?
    
    var realmService: RealmServiceProtocol?
    var dispatchQueue: DispatchQueueType?
    
    var gameProvider = MoyaProvider<MoyaService>()
    
    init(realmService: RealmServiceProtocol = RealmService.shared,
         dispatchQueue: DispatchQueueType = DispatchQueue.main) {
        self.realmService = realmService
        self.dispatchQueue = dispatchQueue
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func fetchData(str: String, optionalURL:  String = "") {
                
        self.searchText = str
        
        gameProvider.request(.getSearch(keyword: str.stripped)) { [weak self] result in
            switch result{
                case .success(let response):
                    guard let strongSelf = self else {return }
                    do{
                        let object = try JSONDecoder().decode(GameApi.self, from: response.data)
                        strongSelf.searchedGameApi = object
                        strongSelf.delegate?.didSearchComplete()
                        strongSelf.dispatchQueue?.async {
                            strongSelf.cleanRealm()
                            strongSelf.saveToRealm()
                        }
                    }catch{
                        print("error")
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func saveToRealm() {
        for i in 0..<(searchedGameApi?.results.count ?? 0) {
            guard let obj = searchedGameApi?.results[i] else{ return }
            do{
                let jsonData = try obj.jsonData()
                // To get dictionary from `Data`
                let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                guard var dictionary = json as? [String : Any] else {
                    return
                }
                //index is used to sort games
                dictionary["index"] = i
                dictionary["key"] = searchText
                dictionary["genres"] = obj.genres.map{ $0.name }
                
                realmService?.create(GameRealm(value: dictionary))
            }catch{
                print("Function: \(#function), line: \(#line)")
            }
            
        }
        UserDefaults.standard.set(searchText, forKey: "key")
    }
    
    func cleanRealm() {
        guard let objects = realmService?.get(GameRealm.self) else{return }
        objects.forEach( {realmService?.delete($0) })
    }
    
    // önceden kaydedilmiş oyunları çekiyor
    func fetchFromRealm(str: String) {
        guard let objects = realmService?.get(GameRealm.self) else{return }
        var games: [Game] = []
        let sameKey = objects.filter("key = '\(str)'")
        
        for i in 0..<10{
            guard let realmObj = sameKey.first(where: { $0.index == i }) else{return }
            
            let genres: [Genre] = realmObj.genres.map{ Genre(name: $0 ?? "") }
            
            games.append(Game(id: realmObj.id, name: realmObj.name, metacritic: realmObj.metacritic, background_image: realmObj.background_image, genres: genres))
        }
        
        self.searchedGameApi = GameApi(results: games)
        delegate?.didSearchComplete()
    }
}
