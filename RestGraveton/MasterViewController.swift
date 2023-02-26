//
//  MasterViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

protocol SelectedDelegate: AnyObject {
    func selectedCell(_ index: Int)
}

class MasterViewController: UIViewController {
    
    var iconMenu: [IconMenu] = [IconMenu(icon: UIImage(systemName: "takeoutbag.and.cup.and.straw")!, name: "Active Orders"), IconMenu(icon: UIImage(systemName: "clock")!, name: "Order History"),
        IconMenu(icon: UIImage(systemName: "gear.circle")!, name: "Settings"),IconMenu(icon: UIImage(systemName: "homekit")!, name: "Store Hours"),IconMenu(icon: UIImage(systemName: "questionmark.circle")!, name: "Help & Support")]
    
    var accountItems = IconMenu(icon: UIImage(named: "logo") ?? UIImage(), name: "Thai Bloom",subName: "Minneapolis")
    
    var defaultHighlightedCell: Int = 0
    
    var collectionView: UICollectionView!
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    weak var delegate: SelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositinLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        view.addSubview(collectionView)
        
        DispatchQueue.main.async {
            
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.collectionView.selectItem(at: defaultRow, animated: false, scrollPosition: .bottom)
        }
        
        collectionView.register(AccountHeaderCell.self, forCellWithReuseIdentifier: AccountHeaderCell.reuseIdentifier)
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        collectionView.delegate = self
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountHeaderCell.reuseIdentifier, for: indexPath) as? AccountHeaderCell else {fatalError("Unable to dequeue")}
                
                cell.logoImageView.image = self.accountItems.icon
                cell.logoLabel.text = self.accountItems.name
                cell.subTitle.text = self.accountItems.subName
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError("Unable to dequeue")}
                
                cell.configureCell(iconMenu: self.iconMenu, indexPath: indexPath)
                
                let myCustomSelectionColorView = UIView()
                myCustomSelectionColorView.backgroundColor = .secondarySystemBackground
                cell.selectedBackgroundView = myCustomSelectionColorView
        
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        
        snapShot.appendItems([accountItems],toSection: Sections.sectionOne)
        snapShot.appendItems(iconMenu, toSection: Sections.sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func compositinLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            
            sectionIndex, layoutEnvironment in
            
            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
                
            case .sectionOne: return self.AccountHeaderSecion()
                
            case .sectionTwo: return self.iconMenuSecion()
                
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        layout.configuration = config
                        
        return layout
    }
    
    func AccountHeaderSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func iconMenuSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 25, trailing: 20)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 20
        
        return layoutSection
    }
}

extension MasterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.selectedCell(indexPath.item)
    }
}
