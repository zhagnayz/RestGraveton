//
//  HelpAndSupportViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class HelpAndSupportViewController: UIViewController {
    
    var iconMenu: [IconMenu] = [
        IconMenu(icon: UIImage(systemName: "phone.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))!, name: "Call Customer Support"),
        IconMenu(icon: UIImage(systemName: "message.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))!, name: "Customer Live Chat"),
        IconMenu(icon: UIImage(systemName: "arrowshape.turn.up.backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))!, name: "Go Back")]
    
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
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
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
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountHeaderCell.reuseIdentifier, for: indexPath) as? AccountHeaderCell else {fatalError("Unable to Deque \(AccountHeaderCell.reuseIdentifier)")}
                
                cell.logoLabel.text = "We are here to help."
                cell.subTitle.text = "You can reach us anytime during operation\n hours by selected options below."
                cell.logoImageView.image = UIImage(systemName: "person.2.badge.gearshape.fill")
            
//                cell.inFoLabel.text = "We are here to help."
//                cell.imageView.image = UIImage(systemName: "person.2.badge.gearshape.fill")
//                cell.instructLabel.text = "You can reach us anytime during operation hours by selected options below"
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError("Unable to dequeue")}
                
                cell.configureCell(iconMenu: self.iconMenu, indexPath: indexPath)
                
                return cell
                
            default:
                return UICollectionViewCell()
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
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        
        snapShot.appendItems([""],toSection: Sections.sectionOne)
        snapShot.appendItems(iconMenu,toSection: Sections.sectionTwo)

        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            
            sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case Sections.sectionOne:
                
                return self.createEmptySection()
                
            case .sectionTwo:
                return self.createButtonsSection()
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
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: view.frame.size.width/3, bottom: 25, trailing: 20)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 30
        return layoutSection
    }
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(100))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
   
    
    @objc func didTapBackToHomeButton(){
        
        navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBar() {

        self.navigationItem.setHidesBackButton(true, animated:false)
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))

        let iconImage = UIImageView(frame: CGRect(x: 0, y: 10, width: 50, height: 50))

        iconImage.image = UIImage(systemName: "line.3.horizontal")?.withTintColor(.label, renderingMode: .alwaysOriginal)


        let labelOne: UILabel = {

            let labelOne = UILabel()
            labelOne.text = "Help & Support"
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


extension HelpAndSupportViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            let number = "6128428261"

            if let url = URL(string: "tel://\(number)"),
                UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else if indexPath.item == 1 {
            
            let phoneNumber = "6128428261"
            
            if let facetimeURL: URL = URL(string: "facetime://\(phoneNumber)") {
              let application:UIApplication = UIApplication.shared
              if (application.canOpenURL(facetimeURL)) {
                application.open(facetimeURL)
              }
            }
        }else if indexPath.item == 2 {
            
            navigationController?.popViewController(animated: true)

        }
        
    }
}
