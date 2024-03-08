//
//  GetRootView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import Foundation
import UIKit

class GetRootView {
    
    static let shared = GetRootView()
    
    func getRootView() -> UIView {
        
        let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        let firstWindow = firstScene?.windows.first

        guard let superView = firstWindow?.rootViewController?.view else {return UIView()}
        
        return superView
    }
}
