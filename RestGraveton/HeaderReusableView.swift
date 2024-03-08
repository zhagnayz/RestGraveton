//
//  HeaderReusableView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    
    static let reuseIdentifier: String = "HeaderReusableView"
        
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        return label
    }()
    
    let info: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let requiredAndOptionalButton: UIButton = {
        let requiredAndOptionalButton = UIButton()
        return requiredAndOptionalButton
    }()
    
    let separator: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .quaternaryLabel
        return view
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let stackViwOne = UIStackView(arrangedSubviews: [title,requiredAndOptionalButton])
        stackViwOne.distribution = .equalSpacing
        
        let stackView = UIStackView(arrangedSubviews: [separator,stackViwOne,info,subtitle])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        stackView.setCustomSpacing(10, after: separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
