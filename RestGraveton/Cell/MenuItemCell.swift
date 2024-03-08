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
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .quaternaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let crossSign: UIImageView = {
        let crossSign = UIImageView()
        crossSign.image = UIImage(systemName: "multiply",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        crossSign.setImageTintColor(.white)
        crossSign.translatesAutoresizingMaskIntoConstraints = false
        return crossSign
    }()
    
    var addItems: [String] = []
    let soleNameLabel = [UILabel]()
    
    var proteinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    var spiceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let addedItemsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [quantityLabel,crossSign,itemNameLabel])
        stackViewOne.spacing = 10
        stackViewOne.alignment = .center
        
        let stackViewThree = UIStackView(arrangedSubviews: [stackViewOne,itemPriceLabel])
        stackViewThree.distribution = .equalCentering
        
        let stackViewTest = UIStackView(arrangedSubviews: [proteinLabel,spiceLabel])
        stackViewTest.axis = .vertical
        
        let stackViewFour = UIStackView(arrangedSubviews: [stackViewTest,addedItemsLabel])
        stackViewFour.spacing = 15
        
        stackViewFour.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [separator,stackViewThree,stackViewFour])
        stackView.spacing = 10
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureMenuItem(_ orderItem:OrderItem?) {
        
        quantityLabel.text = "\(orderItem?.quantity ?? 0)"
        itemNameLabel.text = orderItem?.name
        spiceLabel.text = orderItem?.spiceLevel

        if let proteins = orderItem?.protein {
            
            if proteins.count == 1 {
                proteinLabel.text = proteins[0]
            }
            
            if  proteins.count == 2{
                proteinLabel.text = proteins[0]
                spiceLabel.text = proteins[1]
            }
        }
        
        itemPriceLabel.text = orderItem?.formattedSubTotal
        
        if let addItems = orderItem?.addItems {
            
            var list:String = ""
            
            for addItem in addItems {
                
                list += "\(addItem)\n\n"
            }
            
            addedItemsLabel.text = list
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
