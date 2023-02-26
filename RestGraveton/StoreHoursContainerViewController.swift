//
//  StoreHoursContainerViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import UIKit


class StoreHoursContainerViewController: UIViewController {

    let  firstStoreHoursView =  FirstStoreHoursView()
    let  secondStoreHoursView =  SecondStoreHoursView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [firstStoreHoursView,secondStoreHoursView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 1
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            firstStoreHoursView.widthAnchor.constraint(equalToConstant: 350)
        ])
        
        setNavigationBar()
    }

    func setNavigationBar() {
                
        self.navigationItem.setHidesBackButton(true, animated:false)
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        
        let iconImage = UIImageView(frame: CGRect(x: 0, y: 10, width: 50, height: 50))
        
        iconImage.image = UIImage(systemName: "line.3.horizontal")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        let labelOne: UILabel = {
            
            let labelOne = UILabel()
            labelOne.text = "Store Hours"
            labelOne.textColor = .label
            labelOne.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            
            return labelOne
        }()
        
        let stackView = UIStackView(arrangedSubviews: [iconImage,labelOne])
        stackView.spacing = 30
        
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
