//
//  EmptyDataCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class EmptyDataCell: UICollectionViewCell {

    static let reuseIdentifier: String = "EmptyDataCell"

    override init(frame:CGRect){
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
