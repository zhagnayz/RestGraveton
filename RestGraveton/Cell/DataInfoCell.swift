//
//  DataInfoCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import UIKit

class DataInfoCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "DataInfoCell"
    
    let name: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let numName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [name,numName])
        stackView.distribution = .equalCentering
    
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(_ iconMenu:IconMenu?){
        
        name.text = iconMenu?.name
        numName.text = iconMenu?.subName
    }
    
    func configureCellInformation(_ information: Information?){
        
        name.text = information?.title
        numName.text = information?.subTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
