//
//  PriceDetailsCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit

class PriceDetailsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "PriceDetailsCell"
    
    let priceDetailsLabelStr: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        return label
    }()
    
    let subTotalLabelStr: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let taxLabelStr: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let totaLabellStr: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let totalItemString: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let subTotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let taxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let totalNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
    
        let stackViewZero = UIStackView(arrangedSubviews: [totalItemString,totalNumLabel])
        stackViewZero.distribution = .equalCentering
        
        let stackViewOne = UIStackView(arrangedSubviews: [subTotalLabelStr,subTotalLabel])
        stackViewOne.spacing = 2
   
        let stackViewFour = UIStackView(arrangedSubviews: [taxLabelStr,taxLabel])
        let stackViewFive = UIStackView(arrangedSubviews: [totaLabellStr,totalLabel])
        stackViewFive.distribution = .equalSpacing
            
        let stackView = UIStackView(arrangedSubviews: [priceDetailsLabelStr,stackViewZero,stackViewOne,stackViewFour,stackViewFive])
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configurePricceDetail(_ order:Order?){

        priceDetailsLabelStr.text = "Price Details"
        subTotalLabelStr.text = "SubTotal"
        taxLabelStr.text = "Tax"
        totaLabellStr.text = "GrandTotal"
        totalItemString.text = "total item"
        
        subTotalLabel.text = order?.formattedSubTotal
        taxLabel.text = order?.formattedTax
        totalLabel.text = order?.formattedGrandTotal
        totalNumLabel.text = "\(order?.orderItem.count ?? 00)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

