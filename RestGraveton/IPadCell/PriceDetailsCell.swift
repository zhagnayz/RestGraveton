//
//  PriceDetailsCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit

class PriceDetailsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "PriceDetailsCell"
    
    let priceDetailsLabelStr = UILabel()
    let subTotalLabelStr = UILabel()
    let taxLabelStr = UILabel()
    let totaLabellStr = UILabel()
    let totalItemString = UILabel()
    
    let subTotalLabel = UILabel()
    let taxLabel = UILabel()
    let totalLabel = UILabel()
    let totalNumLabel = UILabel()
    
    let separator = UIView(frame: .zero)
    let separatorTwo = UIView(frame: .zero)
    let separatorThree = UIView(frame: .zero)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        
        priceDetailsLabelStr.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        priceDetailsLabelStr.textColor = .label
        
        totalItemString.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        totalNumLabel.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        totalNumLabel.textColor = .gray
        totalItemString.textColor = .gray

        subTotalLabelStr.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        subTotalLabelStr.textColor = .gray
        subTotalLabel.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        subTotalLabel.textColor = .gray
        
        taxLabelStr.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        taxLabel.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        taxLabel.textColor = .gray
        taxLabelStr.textColor = .gray
        
        totaLabellStr.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        totaLabellStr.textColor = .gray
        totalLabel.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        totalLabel.textColor = .gray

        
        separatorTwo.translatesAutoresizingMaskIntoConstraints = false
        separatorTwo.backgroundColor = .quaternaryLabel
        
        separatorThree.translatesAutoresizingMaskIntoConstraints = false
        separatorThree.backgroundColor = .quaternaryLabel
    
        let stackViewZero = UIStackView(arrangedSubviews: [totalItemString,totalNumLabel])
        stackViewZero.distribution = .equalCentering
        
        let stackViewOne = UIStackView(arrangedSubviews: [subTotalLabelStr,subTotalLabel])
        stackViewOne.spacing = 2
   
        let stackViewFour = UIStackView(arrangedSubviews: [taxLabelStr,taxLabel])
        let stackViewFive = UIStackView(arrangedSubviews: [totaLabellStr,totalLabel])
        stackViewFive.distribution = .equalSpacing
        
        let stackViewSix  = UIStackView(arrangedSubviews: [separatorTwo])
      
        
        let stackView = UIStackView(arrangedSubviews: [separatorThree,priceDetailsLabelStr,stackViewZero,stackViewOne,stackViewFour,stackViewFive,stackViewSix])
        
        
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            separatorTwo.heightAnchor.constraint(equalToConstant: 1),
            separatorThree.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        //stackView.setCustomSpacing(10, after: separator)
        
    }
    
    
    func configurePricceDetail(_ orderHistory: Order){
        
        priceDetailsLabelStr.text = "Price Details"
        subTotalLabelStr.text = "SubTotal"
        taxLabelStr.text = "Tax"
        totaLabellStr.text = "GrandTotal"
        totalItemString.text = "total item"
        
        subTotalLabel.text = "\(orderHistory.formattedSubTotal)"
        taxLabel.text = "\(orderHistory.formattedTax)"
        totalLabel.text = "\(orderHistory.formattedGrandTotal)"
        totalNumLabel.text = "\(orderHistory.items.count)"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

