//
//  AccountCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class AccountCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "AccountCell"
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let subName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [name,subName])
        stackViewOne.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [imageView,stackViewOne])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 30
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            //stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureCell(iconMenu: [IconMenu],indexPath: IndexPath){
        
        imageView.image = iconMenu[indexPath.item].icon
        name.text = iconMenu[indexPath.item].name
        //subName.text = iconMenu[indexPath.item].subName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

