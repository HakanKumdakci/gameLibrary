//
//  Game.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import Foundation
import UIKit

struct GameApi: Codable{
    var count: Int
    var next: String?
    var previous: String?
    var results: [Game]
}

struct Game: Codable{
    var id: Int
    var name: String
    var metacritic: Int?
    var background_image: String?
    var genres: [Genre]
}

struct Genre: Codable{
    var name: String
}


struct GameDetail: Codable{
    var name: String
    var description: String
    var background_image: String
    
    var reddit_url: String?
    var website: String?
}
