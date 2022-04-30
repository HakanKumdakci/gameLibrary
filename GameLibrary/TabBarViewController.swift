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
        
        setUpViewControllers()
        
        self.tabBar.backgroundColor = UIColor.clear
        
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = self.tabBar.bounds
        self.tabBar.insertSubview(frost, at: 0)
        // Do any additional setup after loading the view.
    }
    
    func setUpViewControllers() {
        let gamesVC = GamesViewController()
        let games = UINavigationController(rootViewController: gamesVC)
        games.tabBarItem = setUpTabBarItem(name: "Games", imageName: "game-console")
        
        let favoriteVC = FavoriteViewController()
        let favorite = UINavigationController(rootViewController: favoriteVC)
        favorite.tabBarItem = setUpTabBarItem(name: "Favorites", imageName: "star")
        
        self.viewControllers = [games, favorite]
    }
    
    func setUpTabBarItem(name: String, imageName: String) -> UITabBarItem{
        guard let image = UIImage(named: imageName),
              let img = UIImage(image: image.withRenderingMode(.alwaysOriginal), targetSize: CGSize(width: 42, height: 32))
        else{
            return UITabBarItem(title: name, image: nil, tag: 0)
        }
        
        var tabBarItem: UITabBarItem!
        if #available(iOS 13.0, *) {
            tabBarItem = UITabBarItem(title: name, image: img, selectedImage: img.withTintColor(.gray, renderingMode: .alwaysOriginal))
        }else {
            tabBarItem = UITabBarItem(title: name, image: img, selectedImage: img)
        }
        return tabBarItem
    }
}
