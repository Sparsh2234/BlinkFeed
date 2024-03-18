//
//  NetworkingManager.swift
//  BlinkFeed
//
//  Created by Sparsh Pai on 2024-03-17.
//

import Foundation

struct Article: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleItem]
}

struct ArticleItem: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: URL
    let urlToImage: URL?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String
}

class NetworkingManager {
    
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=476ce120c9f142e1b96561ccf8cb064c")!
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let responseData = data else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            completion(.success(responseData))
        }
        task.resume()
    }
    
    func fetchDataFor(keyword: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let baseUrl = "https://newsapi.org/v2/everything"
        let apiKey = "476ce120c9f142e1b96561ccf8cb064c"
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "\(baseUrl)?q=\(query)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data for \(keyword): \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response for \(keyword)")
                let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received for \(keyword)")
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }

    
    
}
