//
//  MoyaService.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 29.04.2022.
//

import Foundation
import Moya

enum MoyaService {
    case getMain(optionalUrl: String = "")
    case getDetail(id: String)
    case getSearch(keyword: String)
}

extension MoyaService: TargetType {
    var baseURL: URL {
        switch self {
            case .getMain(let optionalUrl):
                if optionalUrl != ""{
                    guard let url = URL(string: optionalUrl) else{return URL(string: "https://jsonplaceholder.typicode.com/posts")! }
                    return url
                }
                guard let api = Bundle.main.object(forInfoDictionaryKey: "baseUrl") as? String,
                      let urlString = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let url = URL(string: urlString) else{
                    return URL(string: "https://jsonplaceholder.typicode.com/posts")!
                }
                
                return url
            case .getDetail(let id):
                guard let api = Bundle.main.object(forInfoDictionaryKey: "gameDetail") as? String,
                      let key = Bundle.main.object(forInfoDictionaryKey: "privateKey") as? String,
                      let url = URL(string: "\(api)/\(id)?key=\(key)") else{
                    return URL(string: "https://jsonplaceholder.typicode.com/posts")!
                }
                return url
            case .getSearch(let keyword):
                guard let api = Bundle.main.object(forInfoDictionaryKey: "gameSearch") as? String,
                      let key = Bundle.main.object(forInfoDictionaryKey: "privateKey") as? String,
                      let urlString = "\(api)\(keyword)&key=\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let url = URL(string: urlString) else{
                    return URL(string: "https://jsonplaceholder.typicode.com/posts")!
                }
                return url
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
            case .getMain(_):
                if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
                        do {
                            let data = try Data(contentsOf: url)
                            return data
                        } catch {
                            print("Function: \(#function), line: \(#line)")
                            return Data()
                        }
                }else{
                    return Data()
                }
            case .getDetail(_):
                if let url = Bundle.main.url(forResource: "dataInstance", withExtension: "json") {
                        do {
                            let data = try Data(contentsOf: url)
                            return data
                        } catch {
                            print("Function: \(#function), line: \(#line)")
                            return Data()
                        }
                }else{
                    return Data()
                }
                
            case .getSearch(_):
                if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
                        do {
                            let data = try Data(contentsOf: url)
                            return data
                        } catch {
                            print("Function: \(#function), line: \(#line)")
                            return Data()
                        }
                }else{
                    return Data()
                }
        }
        
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}

