//
//  AppState.swift
//  Requests
//
//  Created by Marco Almeida on 1/2/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//


import Foundation

class AppState
{
    static let sharedInstance = AppState()
    
    var signedIn = false
    var userName: String?
    var myReqKey: String?

}