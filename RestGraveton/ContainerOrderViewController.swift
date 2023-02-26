//
//  ContainerOrderViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit


class ContainerOrderViewController: UIViewController {
    
    let firstAcOrVC = FirstActiveOrderViewController()
    let secondtAcOrVC = SecondActiveOrderViewController()
    
    var user: [User] {
        
        return IpadDataManager.shared.user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstAcOrVC.user = user
        secondtAcOrVC.user = user[0]
        
        firstAcOrVC.delegate = secondtAcOrVC
        
        let navFirstVC = UINavigationController(rootViewController:  firstAcOrVC)
        let navSecondVC = UINavigationController(rootViewController: secondtAcOrVC)
        
        let stackView = UIStackView(arrangedSubviews: [navFirstVC.view,navSecondVC.view])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0.3
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            navFirstVC.view.widthAnchor.constraint(equalToConstant: 350)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(backToMain), name: NSNotification.Name("com.user.history"), object: nil)
        
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
        ])
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    @objc func didTapPrintButton(){
        share(text: "Daniel")
    }
    
    @objc func didTapIssueWithOrderButton(){
        print("work")
    }
    
    func share(text: String) {
        
        let str = NSAttributedString(string: text)
        let print = UISimpleTextPrintFormatter(attributedText: str)
        
        let vc = UIActivityViewController(activityItems: [print], applicationActivities: nil)
        
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: [textToShare,print], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [.airDrop]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setNavigationBar() {
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        let customAcceptingOrderView = CustomAcceptingOrderView()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 550, height: 80))
        
        let iconImage = UIImageView(frame: CGRect(x: 0, y: 10, width: 60, height: 50))
        
        iconImage.image = UIImage(systemName: "line.3.horizontal")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        let labelOne: UILabel = {
            let labelOne = UILabel()
            labelOne.text = "Order"
            labelOne.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            return labelOne
        }()
        
        let stackViewOne = UIStackView(arrangedSubviews: [iconImage,labelOne])
        stackViewOne.spacing = 15
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,customAcceptingOrderView])
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
