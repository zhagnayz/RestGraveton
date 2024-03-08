//
//  TextFieldCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 7/13/23.
//

import UIKit

class TextFieldCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TextFieldCell"
    
    let textField: CustomTextField = {
        
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHighlightedOnEdit = true
        textField.highlightedColor = .gray
        
        // Setting up small placeholder
        textField.smallPlaceholderColor = .white
        textField.smallPlaceholderFont = UIFont.systemFont(ofSize: 16)
        textField.smallPlaceholderPadding = 12
        textField.smallPlaceholderLeftOffset = 0
        
        textField.placeholderColor = .gray
        textField.textColor = .white
        
        textField.separatorIsHidden = false
        textField.separatorLineViewColor = textField.smallPlaceholderColor
        textField.separatorLeftPadding = -8
        textField.separatorRightPadding = -8
        textField.font = UIFont.systemFont(ofSize: 25)
        
        return textField
    }()
    
    var placeHolderr: String? {
        
        didSet {
            
            guard let userInfo = placeHolderr else {return}
            textField.smallPlaceholderText = userInfo
            
            textField.placeholder = userInfo
        }
    }
    
    let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .quaternaryLabel
        return view
    }()
        
    override init(frame:CGRect){
        super.init(frame: frame)
  
        
        let stackView = UIStackView(arrangedSubviews: [textField,lineView])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1),
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

