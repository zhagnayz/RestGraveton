//
//  HelpAndSupportViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HelpAndSupportViewController: UIViewController {
    
    private var iconMenu = [IconMenu(icon:"phone", name: "Call Customer Support"),IconMenu(icon:"message", name: "Customer Live Chat"), IconMenu(icon: "rectangle.portrait.and.arrow.right", name: "Logout for now"),IconMenu(icon: nil, name: "  account Deletion")]
    
    private var iconInfo = IconMenu(icon: "person.2.badge.gearshape", name: "We are here to help.",subName: "You can reach us anytime during operation\n hours by selected options below.")
    
    private var  phoneNumber = "6128428261"
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
                
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(AccountHeaderCell.self, forCellWithReuseIdentifier: AccountHeaderCell.reuseIdentifier)
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        setNavigationBar()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){
            
            collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountHeaderCell.reuseIdentifier, for: indexPath) as? AccountHeaderCell else {fatalError()}
                cell.logoImageView.layer.borderColor = UIColor.clear.cgColor
                cell.logoImageView.setImageTintColor(.gray)
                cell.configureCell(item as? IconMenu)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError()}
                
                cell.configureFrom(item as? IconMenu)
                
                if indexPath.item == 3 {
                    cell.name.textColor = .systemRed
                }
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.title.text = "Graveton Support"
            sectionHeader.subtitle.text = "How can we help?"
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo])
        
        snapShot.appendItems([iconInfo],toSection: .sectionOne)
        snapShot.appendItems(iconMenu,toSection: .sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            
            sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createEmptySection()
            case .sectionTwo: return self.createButtonsSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        layout.configuration = config
        
        return layout
    }
    
    func createEmptySection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutHeaderSection = createCategoryHeaderSection()
        
        layoutSection.boundarySupplementaryItems = [layoutHeaderSection]
        
        return layoutSection
    }
    
    func createButtonsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 350, bottom: 25, trailing: 350)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 30
        return layoutSection
    }
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(70))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
    
    func setNavigationBar() {
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let navigationBarView = UIView()
        
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)).withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
            return button
        }()
        
        let labelOne: UILabel = {
            let labelOne = UILabel()
            labelOne.text = "help & support"
            labelOne.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            return labelOne
        }()
        
        let stackView = UIStackView(arrangedSubviews: [backButton,labelOne])
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBarView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: navigationBarView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: navigationBarView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo:navigationBarView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: navigationBarView.bottomAnchor)
        ])
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationBarView)
    }
    
    @objc func backToMain(){
        navigationController?.popViewController(animated: true)
    }
    
    func createAlernController(_ title:String,_ message:String,_ bttonTitle:String,_ sdBttTitle:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: bttonTitle, style: .destructive) { (action:UIAlertAction!) in
            
            if bttonTitle == "Logout" {self.logoutUser()
                return}
            
            if let user = Auth.auth().currentUser {
                
                user.delete(){ error in
                    
                    if let error = error {
                        self.navigationItem.title = error.localizedDescription
                    }else{
                        UserDefaults.standard.removeObject(forKey: "uid")
                        Database.database().reference().child("delete").setValue(["uid":user.uid])
                        self.logoutUser()
                    }
                }
            }else{
                self.createAlernController("Error found", "logOut then signIn again, then tap delete", "Logout", "Cancel")
            }
        }
        
        alertController.addAction(yesAction)
        let cancelAction = UIAlertAction(title:sdBttTitle, style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func logoutUser(){
        
        CameraManager.shared.stringUID = nil
        
        let loginNavController = UINavigationController(rootViewController: SignInViewController())
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}

extension HelpAndSupportViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            if let url = URL(string: "tel://\(phoneNumber)"),UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else if indexPath.item == 1 {
            
            if let facetimeURL = URL(string: "facetime://\(phoneNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(facetimeURL)) {
                    application.open(facetimeURL)
                }
            }
        }else if indexPath.item == 2 {
            let taskVC =  UINavigationController(rootViewController: SignInViewController())
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(taskVC)
        }else if indexPath.item == 3 {
            createAlernController("Deleteting Account", "will clear all related information to you.", "Yes", "No")
        }
    }
}
