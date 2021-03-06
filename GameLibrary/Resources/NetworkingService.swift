//
//  NetworkingService.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit

protocol NetworkingServiceProtocol: AnyObject {
    
    func getData<T: Codable>(_ t: T.Type, url: String, completion: @escaping(T) -> Void)
}

class NetworkingService: NSObject, NetworkingServiceProtocol {
    
    
    func getData<T: Codable>(_ t: T.Type, url: String, completion: @escaping(T) -> Void) {
        
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{return }
        guard let url = URL(string: urlString) else{return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{
                print("Could not find any meaningful connect!")
                return
            }
            
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                let json = try JSONSerialization.data(withJSONObject: jsonDict ?? [])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                let object = try decoder.decode(T.self, from: json)
                completion(object)
            } catch {
                print("Function: \(#function), line: \(#line)")
            }
            
        }
        task.resume()
    }
}
