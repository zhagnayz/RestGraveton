//
//  CustomAcceptingOrderView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class CustomAcceptingOrderView: UIView {
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let acceptingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Accepting", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
    
        let stackView = UIStackView(arrangedSubviews: [lineView,acceptingButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.alignment = .center
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 25),
            lineView.widthAnchor.constraint(equalToConstant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

