//
//  NotificationView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 7/26/23.
//

import UIKit


func getNofiticiationView(_ error:String,isError:Bool) -> UIView{
    
    var notificationView = NotificationView()
    notificationView.changeBackground(error, isError:isError)
    
    return notificationView
}

class NotificationView: UIView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func changeBackground(_ text:String,isError:Bool){
        
        self.nameLabel.text = text
        
        if isError {
            self.nameLabel.textColor = .red
        }else{
            self.nameLabel.textColor = .white
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
