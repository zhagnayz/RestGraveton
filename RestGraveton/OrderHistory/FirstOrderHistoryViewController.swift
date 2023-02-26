//
//  FirstOrderHistoryViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit

class FirstOrderHistoryViewController: UIViewController {
    
    var user: [User] = []
    
    enum Sections: Int {
        
        case sectionOne
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    var isSelectedButton: Bool = false
    
    var TestView: UIView!
    var defaultHighlightedCell: Int = 0
    weak var delegate: inputDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            
            self.collectionView.selectItem(at: defaultRow, animated: false, scrollPosition: .bottom)
        }
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.register(ClientInfoCell.self, forCellWithReuseIdentifier: ClientInfoCell.reuseIdentifier)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){
            
            collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClientInfoCell.reuseIdentifier, for: indexPath) as? ClientInfoCell else {fatalError("Unable to Deque \(ClientInfoCell.reuseIdentifier)")}
                    
                cell.configureCell(self.user, indexPath)
                cell.dotView.isHidden = false
                
                let myCustomSelectionColorView = UIView()
                myCustomSelectionColorView.backgroundColor = .secondarySystemBackground
                cell.selectedBackgroundView = myCustomSelectionColorView
                
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.title.text = "completed"
            sectionHeader.requiredAndOptionalButton.setTitle("\(self.user.count) order(s)", for: .normal)
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne])
        
        snapShot.appendItems(user,toSection: Sections.sectionOne)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            
            sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case Sections.sectionOne: return self.createClientInfosSection()
            }
        }
        
        return layout
    }
    
    func createClientInfosSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(90))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutHeaderSection = createCategoryHeaderSection()
        
        layoutSection.boundarySupplementaryItems = [layoutHeaderSection]
        
        return layoutSection
    }
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .estimated(80))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
}

extension FirstOrderHistoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let selectedUser = user[indexPath.item]
            
            delegate?.getData(selectedUser)
        }
    }
}
