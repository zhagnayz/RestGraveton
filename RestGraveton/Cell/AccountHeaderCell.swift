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
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0.3
        image.layer.borderColor = UIColor.white.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 60
        return image
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30,weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
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
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    func configureCell(_ iconMenu:IconMenu?){
        
        if let image = iconMenu?.icon {
            
            logoImageView.image = UIImage(systemName: image)
        }else{
            logoImageView.image = UIImage(systemName: "circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        }
        
        logoLabel.text = iconMenu?.name
        subTitle.text = iconMenu?.subName
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


