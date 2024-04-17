//
//  NewsViewModelInteractor.swift
//  KekaAssignment
//
//  Created by Shaikh Rakib on 17/04/24.
//

import Foundation


class NewsViewModelInteractor<DataFetcherType: DataFetcher, DataStorerType: DataStorable> {
    let networkAvailabilityChecker: NetworkAvailabilityChecker
    private var dataFetcher: DataFetcherType
    private var dataStorer: DataStorerType
    
    init(dataFetcher: DataFetcherType,
         dataStorer: DataStorerType) {
        self.dataFetcher = dataFetcher
        self.dataStorer = dataStorer
        self.networkAvailabilityChecker = NetworkAvailabilityManager()
    }
    
    func fetchNews(completion: @escaping (Result<DataFetcherType.DataType, Error>) -> Void) {
        dataFetcher.fetchData { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveData(data: DataStorerType.DataType) throws {
        try dataStorer.saveData(data)
    }
}
