//
//  ViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class ViewController: UIViewController {
    
    var masterVC = MasterViewController()
    var emptyOrdersView = EmptyOrdersView()
    
    let orderCustomView = OrderCustomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masterVC.delegate = self
        
        orderCustomView.addNewButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
//
//            self.orderCustomView.getOrderCustomView(firstButton: "Accept", secondButton: "Reject", title: "1", subTile: "Order", on: self)
//
//            self.getSting(UIView(), UIView())
//
//        })
        
        getSting(masterVC.view, emptyOrdersView)
    }
    
    @objc func didTapAcceptButton(){
        
        self.getSting(masterVC.view, emptyOrdersView)
        
        orderCustomView.removeOrderCustomView()
    }
    
    func getSting(_ firstView: UIView, _ secondView: UIView){
        
        let stackView = UIStackView(arrangedSubviews: [firstView,secondView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0.3
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            masterVC.view.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}

extension ViewController: SelectedDelegate {
    
    func selectedCell(_ index: Int) {
        
        switch index {
            
        case 0:
            
            if IpadDataManager.shared.user.count > 0 {
                let activeOrderVC = ContainerOrderViewController()
                navigationController?.pushViewController(activeOrderVC, animated: true)
            }
            
        case 1:
            let orderHistoryVC = OrderHistoryContainerViewController()
            navigationController?.pushViewController(orderHistoryVC, animated: true)
            
        case 2:
            let settingsVC = SettingViewController()
            navigationController?.pushViewController(settingsVC, animated: true)
            
        case 3:
            
            let storeHoursVC = StoreHoursContainerViewController()
            navigationController?.pushViewController(storeHoursVC, animated: true)
            
        case 4:
            let helpAndSupportVC = HelpAndSupportViewController()
            navigationController?.pushViewController(helpAndSupportVC, animated: true)
            
        default:
            break
        }
    }
}
