//
//  NewsListViewModel.swift
//  KekaAssignment
//
//  Created by Shaikh Rakib on 17/04/24.
//

import Foundation
import SwiftUI

class NewListViewModel<DataFetcherType: DataFetcher, DataStorerType: DataStorable>: ObservableObject {
    @Published var arrNews: [News] = []
    var sortedNews: [News] {
        arrNews.sorted{$0.pubDate ?? Date() > $1.pubDate ?? Date()}
    }
    @Published var isLoading = false
    private var interactor: NewsViewModelInteractor<NewsDataFetcher, NewsDataStorer>
        
    init(interactor: NewsViewModelInteractor<NewsDataFetcher, NewsDataStorer>) {
        self.interactor = interactor
    }
    
    func fetchNews() {
        if interactor.networkAvailabilityChecker.isNetworkAvailable {
            interactor.fetchNews { result in
                switch result {
                case .success(let data):
                    try? self.interactor.saveData(data: data)
                    DispatchQueue.main.async {
                        self.arrNews = CoreDataManager.shared.fetch(entityType: News.self)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.arrNews = CoreDataManager.shared.fetch(entityType: News.self)
        }
    }
}
