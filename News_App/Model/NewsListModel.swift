//
//  NewsModel.swift
//  News_App
//
//  Created by user on 26/02/21.
//

import Foundation
import Alamofire
import RxSwift
protocol NewsListModelProtocol {
    func fetchNewsForPage(index:Int)-> Single<[Articles]>
    
    func searchForNewsWithKey(key:String)-> Single<[Articles]>
    
    var totalCount:Int? {get set}
}


class NewsListModel:NewsListModelProtocol {
    
    private let disposeBag = DisposeBag()
    var totalCount:Int? = 0
    func fetchNewsForPage(index:Int)-> Single<[Articles]> {
        guard let requestUrl = URL(string: "https://newsapi.org/v2/top-headlines") else { return Single.error(AppError.invalidUrl)}
        let parameters = ["pageSize":10,
                                     "page":index,
                                     "apiKey":"f925127cc00c44148a165819b2f8533d",
                                     "country":"in"] as [String : Any]
        return ApiManager.shareInstance.request(endpoint: APIEndPoint.topHeadlines, method: .get,parameters: parameters).flatMap {[weak self] (response:NewsResponse) -> Single<[Articles]> in
            if let articles = response.articles {
                self?.totalCount = response.totalResults!
                return Single.just(articles)
            } else {
               return Single.just([])
            }
           
        }


    }
    
    
    func searchForNewsWithKey(key:String)-> Single<[Articles]> {
        
        let parameters = ["q":key,
                          "apiKey":"f925127cc00c44148a165819b2f8533d",
                          "country":"in"] as [String : Any]
        return ApiManager.shareInstance.request(endpoint: APIEndPoint.topHeadlines, method: .get,parameters: parameters).flatMap {[weak self] (response:NewsResponse) -> Single<[Articles]> in
            if let articles = response.articles {
                return Single.just(articles)
            } else {
               return Single.just([])
            }
           
        }
    }
    
    
    
    
}
