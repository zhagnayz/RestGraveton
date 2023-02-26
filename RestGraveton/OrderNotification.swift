//
//  OrderNotification.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import Foundation
import UIKit

fileprivate let bannerHeight: CGFloat = 500

class OrderCustomView {
    
    let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemRed
        //backgroundView.alpha = 0.0
        
        return backgroundView
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 100,weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let subTitleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30,weight: .semibold)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let addNewButton: UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.backgroundColor = .red

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let repeatOrderButton: UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        button.setTitleColor(.red, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let panelView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        
        return view
    }()
    
    private var myTargetView: UIView?
    
    let getRootView = GetRootView()
    
    
    func getOrderCustomView(firstButton: String,secondButton:String,title: String,subTile:String, on viewController: UIViewController){
        
        guard let targetView = viewController.view else {return}
        myTargetView = targetView
        
        addNewButton.setTitle(firstButton, for: .normal)
        repeatOrderButton.setTitle(secondButton, for: .normal)
        titleLabel.text = title
        subTitleLabel.text = subTile
        
        backgroundView.frame = targetView.bounds
        
        
        let superView = getRootView.getRootView()
        
        superView.addSubview(backgroundView)
        
        
        backgroundView.addSubview(panelView)
        
        panelView.frame = CGRect(x: 315, y: targetView.frame.size.height/4, width: targetView.frame.size.width - 630, height: bannerHeight)
        
        //targetView.addSubview(panelView)
        
        let stackViewOne = UIStackView(arrangedSubviews: [titleLabel,subTitleLabel])
        stackViewOne.axis = .vertical
        
       
        let stackViewTwo = UIStackView(arrangedSubviews: [addNewButton,repeatOrderButton])
        stackViewTwo.axis = .vertical
        stackViewTwo.spacing = 120
        
        let stackViewThree = UIStackView(arrangedSubviews: [stackViewOne,stackViewTwo])
        stackViewThree.axis = .vertical
        stackViewThree.spacing = 50
        
        let stackView = UIStackView(arrangedSubviews: [stackViewThree])
                
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        panelView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: panelView.leadingAnchor,constant: 30),
            stackView.topAnchor.constraint(equalTo: panelView.topAnchor,constant: 30),
            stackView.trailingAnchor.constraint(equalTo: panelView.trailingAnchor,constant: -30),
            addNewButton.heightAnchor.constraint(equalToConstant: 70),
            repeatOrderButton.heightAnchor.constraint(equalToConstant: 30),
             stackView.bottomAnchor.constraint(equalTo: panelView.bottomAnchor),
        ])
        
        
        UIView.animate(withDuration:0.25, animations: {
            
            //self.backgroundView.alpha = 1.0
            self.backgroundView.backgroundColor = .red
            
        },completion: { isDone in
            
            if isDone {
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.panelView.frame = CGRect(x: 315, y: targetView.frame.size.height/4, width: targetView.frame.size.width - 630, height: bannerHeight)
                    self.panelView.layer.cornerRadius = self.panelView.frame.size.width/2
                })
            }
        })
    }
    
    func TestingremoveOrderCustomView(){
        
        guard let targetView = myTargetView else {return}
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        
        UIView.animate(withDuration:0.25, animations: {
            
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        },completion: { isDone in
            
            if isDone {
                
                UIView.animate(withDuration: 0.25,delay: 2, animations: {
                    
                    self.backgroundView.alpha = 0
                    self.panelView.frame = CGRect(x: 0, y: targetView.frame.size.height, width: targetView.frame.size.width, height: bannerHeight)
                },completion: { isDone in
                    
                    if isDone {
                        self.panelView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                })
            }
        })
    }
    
    func removeOrderCustomView(){
        
        guard let targetView = myTargetView else {return}
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.panelView.frame = CGRect(x: 0, y: targetView.frame.size.height, width: targetView.frame.size.width, height: bannerHeight)
        },completion: { isDone in
            
            if isDone {
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.backgroundView.alpha = 0
                },completion: { isDone in
                    
                    if isDone {
                        
                        self.panelView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                })
            }
        })
    }
}
