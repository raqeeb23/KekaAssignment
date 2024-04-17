//
//  DataFetcher.swift
//  KekaAssignment
//
//  Created by Shaikh Rakib on 17/04/24.
//

import Foundation

// Protocol for fetching data
protocol DataFetcher {
    associatedtype DataType
    func fetchData(completion: @escaping (Result<DataType, Error>) -> Void)
}

class NewsDataFetcher: DataFetcher {
    typealias DataType = [Doc]
    
    func fetchData(completion: @escaping (Result<[Doc], any Error>) -> Void) {
        guard let url = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM") else { return }
        APIService().request(url: url) {(result: Result<NewsReponse,APIError>) in
            switch result {
            case .success(let response):
                guard let news = response.response?.docs else { return }
                completion(.success(news))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
