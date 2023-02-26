//
//  AccountHeaderCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class AccountHeaderCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "AccountHeaderCell"
    
    let logoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let logoLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35,weight: .semibold)
        label.textAlignment = .center

        return label
    }()
        
    let subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray

        return label
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
    
        let stackViewOne = UIStackView(arrangedSubviews: [logoLabel,subTitle])
        stackViewOne.alignment = .center
        stackViewOne.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [logoImageView,stackViewOne])
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 235),
            logoImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
//    func configureCell(name:PersonInfo){
//
//        nameInitialLabel.text = name.getNameInitials()
//        fullNameLabel.text = name.getFullName()
//        emailLabel.text = name.email
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


