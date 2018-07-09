//
//  NetworkingHelper.swift
//  URLSessionDemo
//
//  Created by Tigran Simonyan on 7/9/18.
//  Copyright © 2018 Tigranakert. All rights reserved.
//

import Foundation

final class NetworkingHelper {
    
    private let API_KEY = "api-key=c852c34d-5488-4340-9cfa-91811ca3c4dd&"
    private let BASE_URL = "https://content.guardianapis.com/search?"
    private let SHOW_FIELDS = "show-fields=bodyText,thumbnail,headline"
    
    static let instance = NetworkingHelper()

    private init() {}

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    func retrieveData(completion: @escaping (_ result: DataModel) -> ()) {
        
        defer {
            dataTask = nil
        }
        
        let urlPath = BASE_URL + API_KEY + SHOW_FIELDS
        
        guard let url = URL(string: urlPath) else {
            print("URL error")
            return
        }
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print("DataTask error: \(String(describing: error?.localizedDescription))")
            } else if data != nil {
                do {
                    let decoder = JSONDecoder()
                    let articlesData = try decoder.decode(Dictionary<String, DataModel>.self, from: data!)
                    completion(articlesData["response"]!)
                } catch let dataError {
                    print("Data error \(String(describing: dataError.localizedDescription))")
                }
            }
        })
        dataTask?.resume()
    }
    
    func retrieveImage(withURL url: URL, completion: @escaping (_ result: Data) -> ()) {
        defer {
            dataTask = nil
        }
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print("Image download error \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let data = data else { return }
            
            completion(data)
        })
        dataTask?.resume()
    }
    
}
