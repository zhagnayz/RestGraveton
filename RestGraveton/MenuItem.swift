//
//  MenuItem.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import Foundation

struct MenuItem: Codable,Hashable {
    
    let id: Int
    let name: String
    let price: Double
    let details: String
    let image: String
    var quantity: Int
    var liked: Bool = false
    
    var foodIngredient: [FoodIngredient]
    
    var formattedQuantity: String {
        
        return String(format: "x %d", quantity)
    }
    
    var formattedPrice: String {
        
        return String(format: "$%.2f", price)
    }
}

