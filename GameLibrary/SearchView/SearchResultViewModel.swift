//
//  SearchResultViewModel.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 9.04.2022.
//

import UIKit

protocol SearchResultViewModelDelegate: AnyObject{
    func didSearchComplete()
}

class SearchResultViewModel: NSObject {
    
    var searchText: String = ""
    var searchedGameApi: GameApi?
    weak var delegate: SearchResultViewModelDelegate?
    
    var service: NetworkingServiceProtocol!
    
    init(service: NetworkingServiceProtocol) {
        self.service = service
    }
    
    func fetchData(str: String, optionalURL:  String = ""){
        let url = (optionalURL == "") ? "https://api.rawg.io/api/games?page_size=10&page=1&search=\(str)&key=3be8af6ebf124ffe81d90f514e59856c" : optionalURL
        if str.count >= 3{
            service.getData(GameApi.self, url: url) { [weak self] result in
                guard let strongSelf = self else {return }
                strongSelf.searchedGameApi = result
                strongSelf.delegate?.didSearchComplete()
            }
            
        }
    }
}
