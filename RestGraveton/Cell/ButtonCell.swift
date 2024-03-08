//
//  ButtonCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ButtonCell"
    
    var name:  UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let subName: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame:CGRect){
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [iconImageView,name,subName])
        stackViewOne.alignment = .center
        stackViewOne.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne])
        stackView.axis = .vertical
        stackView.alignment = .center

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 45),
            iconImageView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func configureCell(_ iconMenu: IconMenu?){
        
        iconImageView.image = UIImage(named: iconMenu?.icon ?? "f")
        name.text = iconMenu?.name
        subName.text = iconMenu?.subName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
