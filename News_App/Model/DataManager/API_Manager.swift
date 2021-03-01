//
//  API_Manager.swift
//  News_App
//
//  Created by user on 26/02/21.
//

import Foundation
import Alamofire
import RxSwift
class ApiManager {
    
    static let shareInstance = ApiManager()
    
    private var baseServerUrl:String {
        #if DEBUG
       return "https://newsapi.org/v2/"
        #elseif RELEASE
       return "https://newsapi.org/v2/"
        #else
        assertionFailure("No configuration flag set.")
        return ""
        #endif
   }
    
    private init() {}
   
     func request<T:Codable>(endpoint:APIEndPoint,method:HTTPMethod,parameters:Parameters)->Single<T> {
        guard let url = URL(string: baseServerUrl+endpoint.rawValue) else {
            return Single.error(AppError.invalidUrl)
        }
       return  Single<T>.create { (single) -> Disposable in
           
            let request =  AF.request(url, method: method, parameters: parameters, headers: nil).validate().responseDecodable { (response:DataResponse<T,AFError>) in
                if let value = response.value {
                    single(.success(value))
                } else  if let error = response.error {
                    return single(.error(error))
                }
                
            }
            return Disposables.create { request.cancel() }
        }
        
    }
    
    
    
}
