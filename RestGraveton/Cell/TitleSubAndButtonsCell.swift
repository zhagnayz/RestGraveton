//
//  TitleSubAndButtonsCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class TitleSubAndButtonsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TitleSubAndButtonsCell"
    
    let inFoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25,weight: .bold)
        return label
    }()
    
    let instructLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    func configureCell(_ information: Information?){
        
        inFoLabel.text = information?.title
         instructLabel.text = information?.subTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

