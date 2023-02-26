//
//  ClientInfoCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class ClientInfoCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ClientInfoCell"
        
    let willDeliveryLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        
        return label
    }()

    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        
        return label
    }()

    let orderNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        
        return label
    
    }()

    let itemNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        
        return label
    }()
    
    let itemsString: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        
        return label
    }()
    
    var readyPickUpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
        
    }()
    
    let lineView = UIView(frame: .zero)
    
    let dotSize = 15

    let dotView = CheckBox()

    override init(frame: CGRect) {
        super.init(frame: frame)
      
        dotView.translatesAutoresizingMaskIntoConstraints = false
                       
        lineView.backgroundColor = .quaternaryLabel
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewSubZero = UIStackView(arrangedSubviews: [itemNumLabel,itemsString])
        stackViewSubZero.spacing = 3
        let stackViewZero = UIStackView(arrangedSubviews: [orderNumLabel,dotView,stackViewSubZero])
                
        let stackViewOne = UIStackView(arrangedSubviews: [stackViewZero,readyPickUpLabel])
        stackViewOne.distribution = .equalCentering
        
        let stackView = UIStackView(arrangedSubviews: [lineView,willDeliveryLabel,nameLabel,stackViewOne])
        stackView.distribution = .fill
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            lineView.heightAnchor.constraint(equalToConstant: 2),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dotView.widthAnchor.constraint(equalToConstant: CGFloat(dotSize)),
            dotView.heightAnchor.constraint(equalToConstant: CGFloat(dotSize))
        ])
    }
    
    func configureCell(_ user: [User]?,_ indexPath: IndexPath){
        
        guard let user = user else {return}
        guard let order = user[indexPath.item].order else {return}

        
        willDeliveryLabel.text = order.couponIncluded ? "CosBot Wil Deliver" : "Client Will Pick Up"
        
        nameLabel.text = user[indexPath.item].personInfo.getNameInitials()
        
       orderNumLabel.text = order.reference
        
      readyPickUpLabel.text = order.date

        for item in order.items {
            itemNumLabel.text = "\(item.quantity)"

        }
        
       itemsString.text = "items"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
