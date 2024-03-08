//
//  SecondOrderHistoryViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit

class SecondOrderHistoryViewController: UIViewController {
    
    var order: Order = Order()
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width - 350, height: view.frame.size.height), collectionViewLayout: createCompositionalLayout())
        
        view.addSubview(collectionView)
        
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifier)
        
        collectionView.register( PriceDetailsCell.self, forCellWithReuseIdentifier:  PriceDetailsCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell else {fatalError()}
                
                cell.configureMenuItem(item as? OrderItem)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  PriceDetailsCell.reuseIdentifier, for: indexPath) as?  PriceDetailsCell else {fatalError()}
                
                var order = item as? Order
                order?.getSubTotal()
                cell.configurePricceDetail(order)
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo])
        
        snapShot.appendItems(order.orderItem, toSection: .sectionOne)
        snapShot.appendItems([order],toSection: .sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createMenuItemSection()
            case .sectionTwo: return self.createMenuItemSection()
            }
        }
        return layout
    }
    
    func createMenuItemSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
}

extension SecondOrderHistoryViewController: inputDataDelegate {
    
    func getData(_ order: Order) {
        self.order = order
        self.reloadData()
    }
}
