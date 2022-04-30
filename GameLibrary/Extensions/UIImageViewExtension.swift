//
//  UIImageViewExtension.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 26.04.2022.
//

import Foundation
import UIKit

extension UIImageView{
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                guard let img = UIImage(data: data) else{ return }
                self?.contentMode = .scaleAspectFit
                self?.image = img
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
