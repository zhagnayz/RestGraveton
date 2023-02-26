//
//  CustomAcceptingOrderView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class CustomAcceptingOrderView: UIView {
    
    let lineView = UIView(frame: .zero)
    
    let acceptingButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Accepting", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .systemBackground
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        
        lineView.backgroundColor = .green
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [lineView,acceptingButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.alignment = .center
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            lineView.heightAnchor.constraint(equalToConstant: 25),
            lineView.widthAnchor.constraint(equalToConstant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

