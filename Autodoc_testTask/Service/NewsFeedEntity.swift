//
//  NewsFeedEntity.swift
//  Autodoc_testTask
//
//  Created by Fixed on 02.12.24.
//

import Foundation

struct Welcome: Decodable {
    let news: [News]
    let totalCount: Int //???
}

struct News: Decodable, Hashable {
    let id: Int
    let title, description, publishedDate, url: String
    let fullURL: String
    let titleImageURL: String? 
    let categoryType: String

    enum CodingKeys: String, CodingKey {
        case id, title, description, publishedDate, url
        case fullURL = "fullUrl"
        case titleImageURL = "titleImageUrl"
        case categoryType
    }
}

