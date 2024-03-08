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
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setImageTintColor(.white)
        return imageView
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
 
        let stackView = UIStackView(arrangedSubviews: [name,imageView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureCell(_ iconMenu: IconMenu?){
        
        imageView.image = UIImage(systemName: iconMenu?.icon ?? "")
        name.text = iconMenu?.name
    }
    
    func configureFrom(_ iconMenu: IconMenu?){
        
        imageView.image = UIImage(systemName: iconMenu?.icon ?? "",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        imageView.setImageTintColor(.gray)
        name.text = iconMenu?.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

