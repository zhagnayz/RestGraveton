//
//  SecondStoreHoursView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import UIKit

class SecondStoreHoursView: UIView {
    
    private var instros = [Information(title: "Speciel Hours and Closures", subTitle: "Add special hours or closures for holidays, special events,or other exceptional events. This will temporarily replace your regular menu hours.")]
    
    private var specialDate = [Information(title:  "Memorial Day", subTitle:"11:00 - 22:00")]

    private var iconMenu = ["+ Add Special Hours or Closures"]
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    var collectionView: UICollectionView!

    weak var delegate: SelectedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: compositinLayout())
        
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
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier, for: indexPath) as? TitleSubAndButtonsCell else {fatalError()}
                
                cell.configureCell(item as? Information)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataInfoCell.reuseIdentifier, for: indexPath) as? DataInfoCell else {fatalError()}
                
                cell.configureCellInformation(item as? Information)
        
                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError()}
                
                cell.name.textColor = .systemBlue
                cell.name.text = item as? String
                
                return cell
            default: return UICollectionViewCell()
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
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree])
        
        snapShot.appendItems(instros,toSection:.sectionOne)
        snapShot.appendItems(specialDate, toSection: .sectionTwo)
        snapShot.appendItems(iconMenu,toSection: .sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func compositinLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
                
            case .sectionOne: return self.CreateInfoSecion()
            case .sectionTwo: return self.createDaySecion()
            case .sectionThree:  return self.CreateInfoSecion()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        layout.configuration = config
        
        return layout
    }
    
    func CreateInfoSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 60, leading: 0, bottom: 0, trailing: 0)
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

    func createOrderHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(80))
        
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
