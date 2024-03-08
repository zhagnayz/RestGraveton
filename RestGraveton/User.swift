//
//  User.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 7/30/23.
//

import Foundation
import UIKit

struct User:Codable, Hashable{
    
    var id:String?
    var orderStatus:String?
    var orderNum:String?
    var timestamp:Double?
    var personInfo = PersonInfo()
    var order = Order()
}
