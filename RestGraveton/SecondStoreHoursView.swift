//
//  SecondStoreHoursView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import UIKit


class SecondStoreHoursView: UIView {
    
    var iconMenu: [IconMenu] = [
        IconMenu(icon: UIImage(systemName: "plus.circle")!, name: "Add Special Hours or Closures")]
    
    var collectionView: UICollectionView!
    
    enum Sections: Int {
        
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    weak var delegate: SelectedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: compositinLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        self.addSubview(collectionView)
        
        collectionView.register(TitleSubAndButtonsCell.self, forCellWithReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(DataInfoCell.self, forCellWithReuseIdentifier: DataInfoCell.reuseIdentifier)
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier, for: indexPath) as? TitleSubAndButtonsCell else {fatalError("\(TitleSubAndButtonsCell.reuseIdentifier)")}
                
                //cell.longButton.isHidden = !cell.longButton.isHidden
                cell.inFoLabel.text = "Speciel Hours and Closures"
                cell.instructLabel.text = "Add special hours or closures for holidays, special events,or other exceptional events. This will temporarily replace your regular menu hours."
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataInfoCell.reuseIdentifier, for: indexPath) as? DataInfoCell else {fatalError("\(DataInfoCell.reuseIdentifier)")}
                
                cell.name.text = "Memorial Day"
                cell.numName.text = "11:00 - 22:00"
                
                //                let myCustomSelectionColorView = UIView()
                //                myCustomSelectionColorView.backgroundColor = .secondarySystemBackground
                //                cell.selectedBackgroundView = myCustomSelectionColorView
                
                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError("\(AccountCell.reuseIdentifier)")}
                
                cell.name.textColor = .systemBlue
                cell.configureCell(iconMenu: self.iconMenu, indexPath: indexPath)
                
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.title.text = "Dates"
            sectionHeader.requiredAndOptionalButton.titleLabel?.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
            sectionHeader.requiredAndOptionalButton.setTitle("Store Availability", for: .normal)
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo,Sections.sectionThree])
        snapShot.appendItems([""],toSection: Sections.sectionOne)
        snapShot.appendItems(["ddd"], toSection: Sections.sectionTwo)
        snapShot.appendItems(iconMenu,toSection: Sections.sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func compositinLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            
            sectionIndex, layoutEnvironment in
            
            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
                
            case .sectionOne:
                return self.CreateInfoSecion()
                
            case .sectionTwo:
                return self.createDaySecion()
                
            case .sectionThree:
                return self.CreateAddButtonSecion()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        config.interSectionSpacing = 50
        
        layout.configuration = config
        
        return layout
    }
    
    func CreateInfoSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createDaySecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 20, bottom: 25, trailing: 20)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutHeaderSection = createOrderHeaderSection()
        
        layoutSection.boundarySupplementaryItems = [layoutHeaderSection]
        
        return layoutSection
    }
    
    func CreateAddButtonSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createOrderHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .estimated(80))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SecondStoreHoursView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.item == 0 {
            
            
        }
    }
}
