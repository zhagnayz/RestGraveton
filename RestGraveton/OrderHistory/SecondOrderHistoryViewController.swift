//
//  SecondOrderHistoryViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit

class SecondOrderHistoryViewController: UIViewController {
    
    var user: User = User(){
        didSet{
            setNavigationBar()
        }
    }
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(collectionView)
        
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifier)
        
        collectionView.register( PriceDetailsCell.self, forCellWithReuseIdentifier:  PriceDetailsCell.reuseIdentifier)
        
        setNavigationBar()
        createDataSource()
        
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell else {fatalError()}
                
                // guard let orderHistory = self.orderHistory else {fatalError()}
                
                cell.quantityLabel.text = "\(self.user.order?.items[indexPath.item].quantity ?? 0)"
                cell.itemNameLabel.text = self.user.order?.items[indexPath.item].name
                cell.itemPriceLabel.text = self.user.order?.items[indexPath.item].formattedTotalPrice
                
                //                for  item in user[indexPath.item].order?.items[indexPath.item].foodIngredient {
                //
                //                    for i in 0..<item.protein.count {
                //
                //                        cell.itemDetailsLabel.text = item.protein[i].name
                //                    }
                //                }
                
                cell.extraDetailLabel.text = "Blasamic Vinagrette ($0.50)"
                cell.arrowButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  PriceDetailsCell.reuseIdentifier, for: indexPath) as?  PriceDetailsCell else {fatalError()}
                
                guard let orderHistory = self.user.order else {fatalError()}
                
                cell.configurePricceDetail(orderHistory)
                
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        snapShot.appendItems(["d"], toSection: Sections.sectionOne)
        snapShot.appendItems(["dd"],toSection: Sections.sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            
            sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case Sections.sectionOne: return self.createMenuItemSection()
                
            case .sectionTwo: return self.createPriceDetrailsSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        layout.configuration = config
        
        return layout
    }
    
    func createMenuItemSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createPriceDetrailsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func setNavigationBar() {
        
        let view = UIView()
        
        let nameLabel: UILabel = {
            
            let appNameLabel = UILabel()
            appNameLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
            appNameLabel.text = user.personInfo.getNameInitials()
            return appNameLabel
        }()
        
        let orderNumLabel: UILabel = {
            
            let labelOne = UILabel()
            labelOne.text = user.order?.reference
            labelOne.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            return labelOne
        }()
        
        let itemNumlabel: UILabel = {
            
            let labelOne = UILabel()
            labelOne.textColor = .gray
            labelOne.font = UIFont.systemFont(ofSize: 12)
            
            if let order = user.order {
                
                for iten in order.items{
                    labelOne.text = "\(iten.quantity)"
                }
            }
            
            return labelOne
        }()
        
        let dotSize = 15
        
        let dotView = CheckBox()
        
        dotView.translatesAutoresizingMaskIntoConstraints = false
        
        let itemStringlabel: UILabel = {
            
            let labelOne = UILabel()
            labelOne.textColor = .gray
            labelOne.font = UIFont.systemFont(ofSize: 12)
            labelOne.text = "items"
            
            return labelOne
        }()
        
        let stackViewOne = UIStackView(arrangedSubviews: [orderNumLabel,dotView,itemNumlabel,itemStringlabel])
        
        stackViewOne.spacing = 3
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewTwo = UIStackView(arrangedSubviews: [nameLabel,stackViewOne])
        stackViewTwo.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [stackViewTwo])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dotView.widthAnchor.constraint(equalToConstant: CGFloat(dotSize)),
            dotView.heightAnchor.constraint(equalToConstant: CGFloat(dotSize)),
            stackViewOne.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    @objc func didTapHyperLocateButton(){}
}

extension SecondOrderHistoryViewController: inputDataDelegate {
    
    func getData(_ user: User) {
        self.user = user
        collectionView.reloadData()
    }
}
