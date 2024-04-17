//
//  DataStorer.swift
//  KekaAssignment
//
//  Created by Shaikh Rakib on 17/04/24.
//

import Foundation

// Protocol for storing data
protocol DataStorable {
    associatedtype DataType
    func saveData(_ data: DataType) throws
}


class NewsDataStorer: DataStorable {
    typealias DataType = [Doc]
    
    func saveData(_ data: [Doc]) throws {
        CoreDataManager.shared.saveObjects(objects: data.map{ $0.newsMapper() }, uniqueIdentifier: "newsId")
    }
}
