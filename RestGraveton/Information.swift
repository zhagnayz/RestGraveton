//
//  Information.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 11/8/23.
//

import Foundation

struct Information: Hashable,Codable {
    
    let title:String
    let subTitle:String
}

struct Policy:Codable,Hashable{
    
    let policy:String
}
