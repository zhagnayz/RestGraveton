//
//  PersonInfo.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import Foundation

struct PersonInfo:Codable, Hashable {
    
    var firstName: String
    var lastName: String
    var email: String
    var phone: String?
    var password: String?
    
    func getFullName() -> String {
        
        let fullName: String = firstName + " " + lastName
        
        return fullName
    }
    
    func getNameInitials() -> String {
        
        return getFullName().components(separatedBy: " ").reduce("") {
            
            let firstLetter = firstName.prefix(1).capitalized
            
            let remainingLetters = firstName.dropFirst().lowercased()
            
            let firstNameCapit = firstLetter + remainingLetters
            
            return ($0.isEmpty ? "" : "\(firstNameCapit)") + " " +
            ($1.isEmpty ? "" : "\(($1.first?.uppercased() ?? "") + ".")")
        }
    }
}
