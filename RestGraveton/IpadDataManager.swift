//
//  IpadDataManager.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import Foundation

class IpadDataManager {
    
    static let shared =  IpadDataManager()
    
    
    var userData: UserData = UserData()
    
    var user: [User] = []{
        
        didSet {
           // NotificationCenter.default.post(name: IpadDataManager.orderUpdateNotification, object: nil)
        }
    }

   // static let orderUpdateNotification = Notification.Name("orderUpdated")
    
    init(){
        
        let userrr = User(personInfo: PersonInfo(firstName: "Daniel", lastName: "Zhagnay Zamora", email: "zhagnayz@psx.edu"),order: Order(reference: "#3343", title: "hand to me", date: "3/4/4", deliveryCharge: 3.99, tip: 2.99, items: [OrderItem(from: MenuItem(id: 1, name: "Pad Thai", price: 12.99, details: "ingredients are provided on the side as condiments, including red chilli pepper, lime wedges and peanuts.", image: "food", quantity: 2, foodIngredient: [FoodIngredient(id: 1, section: "sectionOne", title: "Order This", subTitle: "Ordered", buttonTitle: "Button", ingredient: [Ingredient(id: 1, name: "Chicken", quantity: 1, price: 2.99, isSelected: true, isChecked: false)])]), restaurantName: "Thai Bloom", itemIndex: 1)]))
        
        let testingUser = User(personInfo: PersonInfo(firstName: "Jose", lastName: "Zamora", email: "zhagnayz@psx.edu"),order: Order(reference: "#9043", title: "hand to me", date: "3/4/4", deliveryCharge: 3.99, tip: 2.99, items: [OrderItem(from: MenuItem(id: 2, name: "Fried rice", price: 14.99, details: "ingredients are provided on the side as condiments, including red chilli pepper, lime wedges and peanuts.", image: "food", quantity: 3, foodIngredient: [FoodIngredient(id: 2, section: "sectionOne", title: "Order This", subTitle: "Ordered", buttonTitle: "Button", ingredient: [Ingredient(id: 1, name: "Beef", quantity: 1, price: 2.99, isSelected: false, isChecked: false)])]), restaurantName: "Thai Bloom", itemIndex: 1)]))
        
        user.append(userrr)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
            
            self.user.insert(testingUser, at: 0)
        })
    }


    
    
    
    
    
    
    
    
    
    //
    //    func saveOrder(_ newOrder: UserData) -> () {
    //
    //        userDataHistory.insert(newOrder, at: 0)
    //
    //        // Store only the last 10 orders
    //        if userDataHistory.count > 10 {
    //            userDataHistory = Array(userDataHistory.prefix(upTo: 10))
    //        }
    //
    //        // Wipe off the Cart
    //        //cart = Cart(title: "Daniel", items: [OrderItem]())
    //    }
}
