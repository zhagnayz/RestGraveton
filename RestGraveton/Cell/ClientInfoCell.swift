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
        label.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        return label
    }()

    let orderNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()

    let itemNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    let itemsString: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    var readyPickUpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let dotSize = 14

    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .quaternaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dotView: CheckBox = {
        let view = CheckBox()
        view.checkedBorderColor = .clear
        view.isChecked = true
        view.checkmarkColor = .white
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    func configureCell(_ user: User?){
                
        willDeliveryLabel.text = user?.orderStatus
        nameLabel.text = user?.personInfo.getNameInitials()
        
        orderNumLabel.text = user?.orderNum
        
        if let seconds = user?.timestamp {
            let timestamp_date = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
            readyPickUpLabel.text = dateFormatter.string(from: timestamp_date)
        }
        
        itemNumLabel.text = "\(user?.order.orderItem.count ?? 0)"
        itemsString.text = "items"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
