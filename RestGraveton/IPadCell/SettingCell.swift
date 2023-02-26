//
//  SettingCell.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import UIKit

class SettingCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "SettingCell"
    
    let iconImageView = UIImageView()
    let name = UILabel()
    
    let warmodroidSwitch = WarmodroidSwitch(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    
    let buttonPanelView = ButtonPanelView()
    let label = UILabel()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        
        name.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        warmodroidSwitch.translatesAutoresizingMaskIntoConstraints = false
        buttonPanelView.delegate = self
        
        buttonPanelView.isHidden = true
        label.isHidden = true
        
        let stackViewOne = UIStackView(arrangedSubviews: [iconImageView,name])
        stackViewOne.spacing = 20
        stackViewOne.distribution = .fill
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,warmodroidSwitch,label,buttonPanelView])
        stackView.distribution = .equalCentering
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 110),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -110),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            warmodroidSwitch.widthAnchor.constraint(equalToConstant: 70),
            warmodroidSwitch.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureCell(iconMenu: [IconMenu],indexPath: IndexPath){
        
        iconImageView.image = iconMenu[indexPath.item].icon
        name.text = iconMenu[indexPath.item].name
        //subName.text = iconMenu[indexPath.item].subName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingCell: ButtonPanelDelegate{
    
    func didTapButtonWithText(_ text: String) {
        label.text = text
    }
}
