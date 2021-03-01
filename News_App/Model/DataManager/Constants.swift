//
//  Constants.swift
//  News_App
//
//  Created by user on 26/02/21.
//

import Foundation

struct Constants {
    static
    
     var baseServerUrl:String {
         #if DEBUG
        return "https://newsapi.org/v2/"
         #elseif RELEASE
        return "https://newsapi.org/v2/"
         #else
         assertionFailure("No configuration flag set.")
         return ""
         #endif
    }
    
}
