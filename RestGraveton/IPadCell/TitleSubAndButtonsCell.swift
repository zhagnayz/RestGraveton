//
//  TitleSubAndButtonsCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class TitleSubAndButtonsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TitleSubAndButtonsCell"
    
    let inFoLabel = UILabel()
    let instructLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inFoLabel.font = UIFont.systemFont(ofSize: 30,weight: .bold)
        
        instructLabel.font = UIFont.systemFont(ofSize: 20)
        instructLabel.textColor = .gray
        instructLabel.numberOfLines = 0
                
        let stackViewOne = UIStackView(arrangedSubviews: [inFoLabel,instructLabel])
        stackViewOne.axis = .vertical
        stackViewOne.alignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne])
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

