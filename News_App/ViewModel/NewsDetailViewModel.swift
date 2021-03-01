//
//  NewsDetailViewModel.swift
//  News_App
//
//  Created by user on 27/02/21.
//

import Foundation


protocol NewsDetailViewModelProtocol {
    var model : NewsDetailModelProtocol { get set}
    var newsImage: URL? {get set}
    var newsTitle: String {get set}
    var newsDescription: String {get set}
    var newsDateText :String? {get set}
    
}

class NewsDetailViewModel: NewsDetailViewModelProtocol {
    var newsDateText: String?
    
    var newsDescription: String
    
    var newsImage: URL?
    
    var newsTitle: String
    
    var model: NewsDetailModelProtocol
    
    init(model: NewsDetailModelProtocol) {
        self.model = model
        newsTitle = model.newsTitle
        newsImage = model.newsImage
        newsDescription = model.newsContent
        newsDateText = "Updated: " + getUpdatedDateFrom(dateString: model.newsPublishedDate)
        
        
    }
    
// MARK:- Update ISO Formatted Date to 'MMM dd hh:mm a' eg: Dec 23 10:33 AM
    
    private func getUpdatedDateFrom(dateString:String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        dateFormatter.dateFormat = "MMM dd hh:mm a"
        let formatedDate = dateFormatter.string(from: date)
        return formatedDate
    }
    
}
