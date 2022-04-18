//
//  SearchResultViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit
import RealmSwift

protocol SearchResultViewModelDelegate: AnyObject{
    func didSearchComplete()
}

class SearchResultViewModel: NSObject {
    
    var searchText: String = ""
    var searchedGameApi: GameApi?
    weak var delegate: SearchResultViewModelDelegate?
    
    var service: NetworkingServiceProtocol!
    var realmService: RealmServiceProtocol!
    var dispatchQueue: DispatchQueueType!
    
    init(service: NetworkingServiceProtocol,
         realmService: RealmServiceProtocol = RealmService.shared,
         dispatchQueue: DispatchQueueType = DispatchQueue.main) {
        self.service = service
        self.realmService = realmService
        self.dispatchQueue = dispatchQueue
    }
    
    func fetchData(str: String, optionalURL:  String = ""){
        
        guard let key = Bundle.main.object(forInfoDictionaryKey: "privateKey") as? String else{ return }
        guard let gameSearch = Bundle.main.object(forInfoDictionaryKey: "gameSearch") as? String else{ return }
        
        self.searchText = str
        let url = (optionalURL == "") ? "\(gameSearch)\(str.stripped)&key=\(key)" : optionalURL
        service.getData(GameApi.self, url: url) { [weak self] result in
            guard let strongSelf = self else {return }
            strongSelf.searchedGameApi = result
            strongSelf.delegate?.didSearchComplete()
            strongSelf.dispatchQueue.async {
                strongSelf.cleanRealm()
                strongSelf.saveToRealm()
            }
        }
    }
    
    
    func saveToRealm(){
        for i in 0..<(searchedGameApi?.results.count ?? 0){
            guard let obj = searchedGameApi?.results[i] else{ return }
            
            let jsonData = try! obj.jsonData()
            // To get dictionary from `Data`
            let json = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            guard var dictionary = json as? [String : Any] else {
                return
            }
            //index is used to sort games
            dictionary["index"] = i
            dictionary["key"] = searchText
            dictionary["genres"] = obj.genres.map{ $0.name }
            
            realmService.create(GameRealm(value: dictionary))
        }
        UserDefaults.standard.set(searchText, forKey: "key")
    }
    
    func cleanRealm(){
        guard let objects = realmService.get(GameRealm.self) else{return }
        for i in objects{
            realmService.delete(i)
        }
    }
    
    // önceden kaydedilmiş oyunları çekiyor
    func fetchFromRealm(){
        guard let objects = realmService.get(GameRealm.self) else{return }
        var games: [Game] = []
        let sameKey = objects.filter("key = '\(searchText)'")
        
        for i in 0..<10{
            guard let realmObj = sameKey.first(where: { $0.index == i }) else{return }
            
            let genres: [Genre] = realmObj.genres.map{ Genre(name: $0 ?? "") }
            
            games.append(Game(id: realmObj.id, name: realmObj.name, metacritic: realmObj.metacritic, background_image: realmObj.background_image, genres: genres))
        }
        
        self.searchedGameApi = GameApi(results: games)
        delegate?.didSearchComplete()
    }
}
