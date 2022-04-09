//
//  TabBarViewController.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gamesVC = GamesViewController()
        let favoriteVC = FavoriteViewController()
        
        let games = UINavigationController(rootViewController: gamesVC)
        let favorite = UINavigationController(rootViewController: favoriteVC)
        
        
        
        let item1 = gamesVC
        let imgConsole = Helper.shared.resizeImage(image: UIImage(named: "game-console")!.withRenderingMode(.alwaysOriginal), targetSize: CGSize(width: 42, height: 32))
        var icon1: UITabBarItem!
        if #available(iOS 13.0, *) {
            icon1 = UITabBarItem(title: "Games", image: imgConsole, selectedImage: imgConsole.withTintColor(.gray, renderingMode: .alwaysOriginal))
        } else {
            icon1 = UITabBarItem(title: "Games", image: imgConsole, selectedImage: imgConsole)
        }
        games.tabBarItem = icon1
        item1.title = "Games"
        
        
        
        let item2 = favoriteVC
        let imgFavorite = Helper.shared.resizeImage(image: UIImage(named: "star")!.withRenderingMode(.alwaysOriginal), targetSize: CGSize(width: 42, height: 32))
        var icon2: UITabBarItem!
        if #available(iOS 13.0, *) {
            icon2 = UITabBarItem(title: "Favorites", image: imgFavorite, selectedImage: imgFavorite.withTintColor(.gray, renderingMode: .alwaysOriginal))
        } else {
            icon2 = UITabBarItem(title: "Favorites", image: imgFavorite, selectedImage: imgFavorite)
        }
        favorite.tabBarItem = icon2
        item2.title = "Favorites"
        
        
        self.viewControllers = [games, favorite]
        // Do any additional setup after loading the view.
    }
    

    

}
