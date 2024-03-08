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
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        return label
    }()
    
    let warmodroidSwitch: WarmodroidSwitch = {
        let warmodroidSwitch = WarmodroidSwitch(frame: CGRect(x:0, y:0, width:80, height:40))
        warmodroidSwitch.translatesAutoresizingMaskIntoConstraints = false
        return warmodroidSwitch
    }()
    
    let buttonPanelView: ButtonPanelView = {
        let  buttonPanelView = ButtonPanelView()
        buttonPanelView.dogButton.setTitle("Loud", for: .normal)
        buttonPanelView.catButton.setTitle("Quiet", for: .normal)
        buttonPanelView.isHidden = true
        return buttonPanelView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        buttonPanelView.delegate = self

        let stackViewOne = UIStackView(arrangedSubviews: [iconImageView,name])
        stackViewOne.spacing = 20
        stackViewOne.distribution = .fill
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,warmodroidSwitch,label,buttonPanelView])
        stackView.distribution = .equalCentering
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 100),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -100),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            warmodroidSwitch.widthAnchor.constraint(equalToConstant: 70),
            warmodroidSwitch.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureCell(_ iconMenu: IconMenu?){
        
        iconImageView.image = UIImage(systemName: iconMenu?.icon ?? "")
        name.text = iconMenu?.name
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
