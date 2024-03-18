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
}
