//
//  CircleNotificationView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/29/24.
//

import UIKit

class CircleNotificationView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 100,weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30,weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35,weight: .semibold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 35
        button.backgroundColor = .quaternarySystemFill
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let rejectButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 35
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.backgroundColor = .quaternarySystemFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .red
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
        
        let stackViewOne = UIStackView(arrangedSubviews: [titleLabel,subTitleLabel])
        stackViewOne.axis = .vertical
        
        let stackViewTwo = UIStackView(arrangedSubviews: [acceptButton,rejectButton])
        stackViewTwo.axis = .vertical
        stackViewTwo.spacing = 120
        
        let stackViewThree = UIStackView(arrangedSubviews: [stackViewOne,stackViewTwo])
        stackViewThree.axis = .vertical
        stackViewThree.spacing = 40
        
        let stackView = UIStackView(arrangedSubviews: [stackViewThree])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -30),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            acceptButton.heightAnchor.constraint(equalToConstant: 70),
            rejectButton.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
