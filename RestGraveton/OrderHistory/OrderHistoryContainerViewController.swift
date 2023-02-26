//
//  OrderHistoryContainerViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit

class OrderHistoryContainerViewController: UIViewController {
    
    let firstVC = FirstOrderHistoryViewController()
    let secondVC = SecondOrderHistoryViewController()
    
    var user: [User] {
        
        return IpadDataManager.shared.userData.userHistory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstVC.user = user
        secondVC.user = user[0]
        
        firstVC.delegate = secondVC
        
        let firstAcOrVC = UINavigationController(rootViewController: firstVC)
        let secondtAcOrVC = UINavigationController(rootViewController: secondVC)
        
        let stackView = UIStackView(arrangedSubviews: [firstAcOrVC.view,secondtAcOrVC.view])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0.3
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            firstAcOrVC.view.widthAnchor.constraint(equalToConstant: 350)
        ])
        
        setNavigationBar()
        setRightNavigationBar()
    }
    
    func setRightNavigationBar(){
        
        let view = UIView()
        
        let printerButton: UIButton = {
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            button.setImage(UIImage(systemName: "printer.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(didTapPrintButton), for: .touchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 3
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            return button
        }()
        
        let issueWithOrderButton: UIButton = {
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 235, height: 35))
            button.setTitle("Issue with Order", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
            button.setTitleColor(.label, for: .normal)
            button.addTarget(self, action: #selector(didTapIssueWithOrderButton), for: .touchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 3
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            return button
        }()
        
        
        let stackView = UIStackView(arrangedSubviews: [printerButton,issueWithOrderButton])
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //stackView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    
    
    @objc func didTapPrintButton(){
        print("work")
    }
    
    @objc func didTapIssueWithOrderButton(){
        print("work")
    }
    func setNavigationBar() {
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 550, height: 80))
        
        let iconImage = UIImageView(frame: CGRect(x: 0, y: 10, width: 50, height: 50))
        
        iconImage.image = UIImage(systemName: "line.3.horizontal")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        let labelOne: UILabel = {
            
            let labelOne = UILabel()
            labelOne.text = "History"
            labelOne.textColor = .label
            labelOne.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            
            return labelOne
        }()
        
        let stackViewOne = UIStackView(arrangedSubviews: [iconImage,labelOne])
        stackViewOne.spacing = 15
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne])
        stackView.spacing = 130
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backToMain(){
        
        navigationController?.popToRootViewController(animated: true)
    }
}


