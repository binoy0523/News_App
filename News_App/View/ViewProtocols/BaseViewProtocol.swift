//
//  BaseViewProtocol.swift
//  News_App
//
//  Created by user on 26/02/21.
//

import Foundation

protocol BaseViewProtocol:AnyObject {
    
    func startSpinner()
    
    func ceaseSpinner()
    
    func showAlertWith(title:String,message:String)
}
