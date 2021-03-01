//
//  NewsDetailModel.swift
//  News_App
//
//  Created by user on 27/02/21.
//

import Foundation

protocol NewsDetailModelProtocol {
    var newsImage : URL? {get set}
    
    var newsTitle : String {get set}
    
    var newsContent :String {get set}
    
    var newsPublishedDate : String {get set}
    
}

class NewsDetailModel: NewsDetailModelProtocol {
    var newsImage: URL?
    
    var newsTitle: String
    
    var newsContent: String
    
    var newsPublishedDate: String
    
    
    init(article:Articles) {
        newsTitle = article.title ?? ""
        newsContent = article.content ?? ""
        newsPublishedDate = article.publishedAt ?? ""
        if let imageStr = article.urlToImage , let imgURL = URL(string: imageStr) {
            newsImage = imgURL
        }
        
    }
}
