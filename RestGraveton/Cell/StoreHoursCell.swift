//
//  StoreHoursCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 7/15/23.
//

import UIKit

class StoreHoursCell: UICollectionViewCell {
    
    static let reuseIdentifier:String = "StoreHoursCell"
    
    var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var daskLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .center
        return label
    }()
    
    var closeLabel: UILabel = {
        let label = UILabel()
        label.text = "close"
        return label
    }()
    
    var leftDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    var rightDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    var checkBox: CheckBox = {
        
        var checkBox = CheckBox()
        checkBox.style = .tick
        checkBox.borderStyle = .rounded
        return checkBox
    }()
    
    var ifCheckmakclose: Bool = false
    var lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [leftDatePicker,daskLabel,rightDatePicker])
        stackViewOne.distribution = .fillEqually
                    
        let stackViewTwo = UIStackView(arrangedSubviews: [checkBox,closeLabel])
        stackViewTwo.distribution = .fillProportionally
        stackViewTwo.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel,stackViewOne,stackViewTwo])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        checkBox.addTarget(self, action: #selector(configureIsSelected), for: .touchDown)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func configureIsSelected(_ sender:UIButton){
        
        sender.isSelected = !sender.isSelected
        ifCheckmakclose = sender.isSelected
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

