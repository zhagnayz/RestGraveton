//
//  Address.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import Foundation

struct Address:Codable,Hashable {

    var streetNumber: String = ""
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var suite: String = ""
    var fullAddress: String = ""
}
