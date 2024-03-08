//
//  EmptyOrdersView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class EmptyOrdersView: UIView {
    
    var imageIcon: UIImageView = {
        let label =  UIImageView()
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30,weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let checkButton:UIButton = {
        let button = UIButton()
        button.setTitle("Double check this item - Often Missing", for: .normal)
        button.setImage(UIImage(systemName: "pencil.and.scribble")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    var color = UIColor()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [imageIcon,titleLabel,subTitleLabel,checkButton])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -150),
            checkButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        checkButton.configuration = createConfig()
    }
    
    func setValues(_ imageName:String?,title:String?,subTitle:String?){
            
        if imageName == "checkmark"{
            color = .systemGreen
        }else{
            color = .lightGray
        }
        
        imageIcon.image = UIImage(systemName: imageName ?? "",withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))?.withTintColor(color, renderingMode: .alwaysOriginal)
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    func createConfig() -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        config.titleAlignment = .center
        return config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
