//
//  Game.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import Foundation
import UIKit
import RealmSwift

struct GameApi: Codable{
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
    var id: Int
    var name: String
    var description: String
    var metacritic: Int?
    var background_image: String
    var reddit_url: String?
    var website: String?
    var genres: [Genre]
}

class GameRealm: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var metacritic: Int = 0
    @objc dynamic var released: String = ""
    @objc dynamic var rating: Double = 0.0
    @objc dynamic var background_image: String = ""
    var genres = List<String?>()
    @objc dynamic var key: String = ""
    @objc dynamic var index: Int = 0
}


