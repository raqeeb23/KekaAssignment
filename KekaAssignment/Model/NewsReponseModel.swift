//
//  NewsReponseModel.swift
//  KekaAssignment
//
//  Created by Shaikh Rakib on 17/04/24.
//

import SwiftUI
import Foundation

struct NewsReponse: Codable {
    let status, copyright: String?
    let response: Response?
}

struct Response: Codable {
    let docs: [Doc]?
}

struct Doc: Codable {
    let id: String?
    let abstract: String?
    let multimedia: [Multimedia]?
    let headline: Headline?
    let pubDate: Date?
    
    enum CodingKeys: String,CodingKey {
        case id = "_id"
        case abstract
        case multimedia
        case headline
        case pubDate = "pub_date"
    }
}

struct Headline: Codable {
    let main: String?
}

struct Multimedia: Codable {
    let url: String?
}

extension Doc {
    func newsMapper() -> News {
        let news = News(context: CoreDataManager.shared.context)
        news.newsId = id ?? ""
        news.headline = headline?.main ?? ""
        news.photoUrl = multimedia?.first?.url ?? ""
        news.pubDate = pubDate
        news.newsDescription = abstract
        return news
    }
}



