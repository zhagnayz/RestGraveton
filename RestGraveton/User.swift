//
//  User.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import Foundation

struct UserData {
    
    var user: [User] = []
    
    var userHistory: [User] = []
    
    
    mutating func removeUser(_ index:Int){
        
        user.remove(at: index)
    }
}

struct User:Codable, Hashable {
    
    var personInfo: PersonInfo!
    var address: Address!
    
    //var cart = Cart(title: nil, status: .delivery)
    //var restaurantsLastViewed = [Restaurant]()
    var orderHistory = [Order]()
    var order: Order?
    
//    mutating func saveViewedRestaurant(_ restaurant: Restaurant) -> () {
//
//        if let existingIndex = restaurantsLastViewed.firstIndex(where: { (element) -> Bool in
//            return (element.name == restaurant.name)
//        }) {
//            restaurantsLastViewed.remove(at: existingIndex)
//        }
//
//        restaurantsLastViewed.insert(restaurant, at: 0)
//
//        // Store only the last 3 viewed restaurants
//        if restaurantsLastViewed.count > 3 {
//            restaurantsLastViewed = Array(restaurantsLastViewed.prefix(upTo: 3))
//        }
//    }
//
//    mutating func saveOrder(_ newOrder: Order) -> () {
//
//        orderHistory.insert(newOrder, at: 0)
//
//        // Store only the last 10 orders
//        if orderHistory.count > 10 {
//            orderHistory = Array(orderHistory.prefix(upTo: 10))
//        }
//
//        // Wipe off the Cart
//        cart = Cart(title: "Daniel", status: .delivery, items: [OrderItem]())
//    }
}
