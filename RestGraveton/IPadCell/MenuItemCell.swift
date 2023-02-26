//
//  MenuItemCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class MenuItemCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "MenuItemCell"
    
    let quantityLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        return label
    }()
        
    let itemNameLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        
        return label
    }()
    
    
    let itemPriceLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        
        return label
    }()
    
    let arrowButton = UIButton()
    
    let itemDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        return label
        
    }()
    
    let extraDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
        
    }()
        
    let separator = UIView(frame: .zero)
    let crossSign = CheckBox()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        crossSign.style = .cross
        crossSign.translatesAutoresizingMaskIntoConstraints = false

        separator.backgroundColor = .quaternaryLabel
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewOne = UIStackView(arrangedSubviews: [quantityLabel,crossSign,itemNameLabel])
        stackViewOne.spacing = 10
        stackViewOne.alignment = .center
        
        let stackViewTwo = UIStackView(arrangedSubviews: [itemPriceLabel,arrowButton])
        stackViewTwo.spacing = 40
        
        let stackViewThree = UIStackView(arrangedSubviews: [stackViewOne,stackViewTwo])
        stackViewThree.distribution = .equalCentering
        
        let stackViewFour = UIStackView(arrangedSubviews: [itemDetailsLabel,extraDetailLabel])
        stackViewFour.axis = .vertical
        
   
        let stackView = UIStackView(arrangedSubviews: [separator,stackViewThree,stackViewFour])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            crossSign.widthAnchor.constraint(equalToConstant: 15),
            crossSign.heightAnchor.constraint(equalToConstant: 15),
        ])
        
        
        stackView.setCustomSpacing(10, after: separator)
        
    }
    
//    func configureMenuItem(_ menu: [MenuItem],indexPath:IndexPath) {
//
//        let menu = menu[indexPath.item]
//
//        itemImage.image = UIImage(named: menu.image)
//        itemTitle.text = menu.name
//        itemDetails.text = menu.details
//        itemPrice.text = menu.formattedPrice
//        buttonPanelView.count = menu.quantity
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
