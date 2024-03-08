//
//  ViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController {
    
    var iconMenu = ["Active Orders","Order History","Settings","Store Hours","Help & Support"]
    
    let reference = Database.database().reference().child("orders")
    
    let containerOrderVC = ContainerOrderViewController()
    
    var image: UIImage?
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    var collectionView: UICollectionView!
    
    var emptyOrdersView = EmptyOrdersView()
    let orderCustomView = OrderCustomView()
    
    var orderIds:[String] = []
    
    let fileManager = FileManager.default
    var restInfo: Information?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        if let data = UserDefaults.standard.object(forKey: "restInfo") as? Data{
            let decodedData = try? JSONDecoder().decode(Information.self, from: data)
            restInfo = decodedData
        }
        
        let imageData = try? Data(contentsOf: getURLFileManager())
        
        if let imageData = imageData {
            image = UIImage(data: imageData)
        }else{
            image = UIImage(named: "AppIcon")
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositinLayout())
        
        view.addSubview(collectionView)
        
        collectionView.register(AccountHeaderCell.self, forCellWithReuseIdentifier: AccountHeaderCell.reuseIdentifier)
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        
        collectionView.delegate = self
        
        orderCustomView.panelView.acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
        orderCustomView.exitButton.addTarget(self, action: #selector(didTapExistButton), for: .touchUpInside)
        orderCustomView.panelView.rejectButton.addTarget(self, action: #selector(didTapExistButton), for: .touchUpInside)

        observeUserOrders()
        getSting(collectionView,emptyOrdersView)
        createDataSource()
        reloadData()
        
        hasOrderNot(0)
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountHeaderCell.reuseIdentifier, for: indexPath) as? AccountHeaderCell else {fatalError()}
                
                cell.logoImageView.image = self.image
                cell.logoLabel.text = self.restInfo?.title
                cell.subTitle.text = self.restInfo?.subTitle
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError()}
                
                cell.name.text = item as? String
                cell.imageView.image = UIImage(systemName: "chevron.forward")
                
                return cell
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo])
        
        snapShot.appendItems([image],toSection: .sectionOne)
        snapShot.appendItems(iconMenu, toSection: .sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func compositinLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
                
            case .sectionOne: return self.AccountHeaderSecion()
            case .sectionTwo: return self.iconMenuSecion()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        layout.configuration = config
        
        return layout
    }
    
    func AccountHeaderSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func iconMenuSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 90, bottom: 25, trailing: 30)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 30
        
        return layoutSection
    }
    
    func observeUserOrders() {
        
        if let uid = CameraManager.shared.stringUID {
            
            Database.database().reference().child("user-orders").child(uid).observe(.childAdded, with: { (snapshot) in
                
                self.orderIds.append(snapshot.key)
                
                self.orderCustomView.getOrderCustomView(firstButton: "Accept", secondButton: "Reject", title: "\(self.orderIds.count)", subTile: "Order", on: self)
            })
        }
    }
    
    @objc func didTapAcceptButton(){
        
        for orderId in orderIds {
            
            getOrderFromDatabase(orderId)
        }
        
        orderIds = []
        
        orderCustomView.removeOrderCustomView()
    }
    
    @objc func didTapExistButton(){
        
        orderCustomView.removeOrderCustomView()
        orderIds = []
    }
    
    func getOrderFromDatabase(_ orderId:String){
        
        reference.child(orderId).observeSingleEvent(of:.value, with: { snapshot in
            
            if let dictionary = snapshot.value as? [String: Any] {
                var user = User()
                user.id = dictionary["id"] as? String
                user.orderStatus = dictionary["orderStatus"] as? String
                user.orderNum = dictionary["orderNum"] as? String
                user.timestamp = dictionary["timestamp"] as? Double
                user.personInfo.fullName = dictionary["personInfo"] as? String
                
                if let secondDictionary = dictionary["foods"] as? [[String:Any]]{
                    
                    for orderItemDictionary in secondDictionary {
                        var orderItem = OrderItem()
                        orderItem.name = orderItemDictionary["name"] as? String
                        orderItem.price = orderItemDictionary["price"] as? Double
                        orderItem.protein = orderItemDictionary["protein"] as? [String]
                        orderItem.spiceLevel = orderItemDictionary["spice"] as? String
                        orderItem.addItems = orderItemDictionary["addItems"] as? [String]
                        orderItem.quantity = orderItemDictionary["quantity"] as? Int
                        user.order.orderItem.append(orderItem)
                    }
                }
                self.containerOrderVC.users.append(user)
            }
        })
        
        reference.child(orderId).updateChildValues(["current":"accepted"])
        hasOrderNot(1)
    }
    
    func getSting(_ firstView: UICollectionView, _ secondView: UIView){
        
        let stackView = UIStackView(arrangedSubviews: [firstView,secondView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0.3
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func testingFunction(){
        showVC(OrderHistoryContainerViewController())
    }
    
    func getURLFileManager() -> URL {
        let documentDictory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathURL = documentDictory.appendingPathComponent("FilePhoto")
        return pathURL
    }
    
    func didTappedCameraButton(){
        
        CameraManager.shared.showActionSheet(vc: self)
        
        CameraManager.shared.imagePickedBlock = { image in
            
            self.saveLogoToStorage(image)
            
            let imageData = image.jpegData(compressionQuality: 1.0)
            do {
                try imageData?.write(to: self.getURLFileManager())
            }catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveLogoToStorage(_ image:UIImage?){
        
        self.image = image
        
        let storageRef = Storage.storage().reference().child("logos")
        
        if let restName = restInfo?.title,let data = image?.pngData() {
            
            let riversRef = storageRef.child("\(restName)")
            
            riversRef.putData(data, metadata: nil)
        }
        self.collectionView.reloadData()
    }
    
    func hasOrderNot(_ item:Int){
        
        if item == 0 {
            emptyOrdersView.setValues("nosign", title: "No orders at moment", subTitle: "concerns, check to see if your tablet is working properly\n farther information,refer to help & support page")
        }else{
            emptyOrdersView.setValues("checkmark", title: "active orders", subTitle: "\(item)")
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            didTappedCameraButton()
        }else if indexPath.section == 1 && indexPath.item == 0 {
            containerOrderVC.vc = self
            showVC(containerOrderVC)
        }else if indexPath.section == 1 && indexPath.item == 1{
            showVC(OrderHistoryContainerViewController())
        }else if indexPath.section == 1 && indexPath.item == 2 {
            showVC(SettingViewController())
        }else if indexPath.section == 1 && indexPath.item == 3 {
            showVC(StoreHoursContainerViewController())
        }else if indexPath.section == 1 && indexPath.item == 4 {
            showVC(HelpAndSupportViewController())
        }
    }
    
    func showVC(_ vc:UIViewController){
        navigationController?.pushViewController(vc, animated: true)
    }
}
