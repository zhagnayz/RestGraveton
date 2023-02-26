//
//  SettingViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class SettingViewController: UIViewController {
    
    var iconMenu: [IconMenu] = [
        IconMenu(icon: UIImage(systemName: "bolt.fill")!, name: "Auto-confirm new Orders"),
        IconMenu(icon: UIImage(systemName: "bell.fill")!, name: "New order alert volume"),
        IconMenu(icon: UIImage(systemName: "bag.fill")!, name: "Create test order"),
        IconMenu(icon: UIImage(systemName: "bolt.fill")!, name: "Alert when Dasher is arriving"),
    ]
    
    var defaultHighlightedCell: Int = 0

    var collectionView: UICollectionView!
    
    enum Sections: Int {
        
        case sectionOne
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
        
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        setNavigationBar()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in
            
            switch indexPath.section {

            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {fatalError("Unable to dequeue")}
                
                cell.configureCell(iconMenu: self.iconMenu, indexPath: indexPath)
                
                cell.warmodroidSwitch.delegate = self

                if indexPath.item == 1 {
                    
                    cell.warmodroidSwitch.isHidden = !cell.warmodroidSwitch.isHidden
                    cell.buttonPanelView.isHidden = !cell.buttonPanelView.isHidden
                    cell.label.isHidden = !cell.label.isHidden
                }
                
                if indexPath.item == 2 {
                    
                    cell.warmodroidSwitch.isHidden = true
                    cell.label.isHidden = false
                    
                }
                
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

            sectionHeader.title.text = "Orders"
            sectionHeader.separator.backgroundColor = .clear
                        
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne])
        snapShot.appendItems(iconMenu,toSection: Sections.sectionOne)
        
        dataSource?.apply(snapShot)
    }
    
    func compositinLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            
            sectionIndex, layoutEnvironment in
            
            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
                
            case .sectionOne: return self.AccountHeaderSecion()
            }
        }
        
        return layout
    }
    
    func AccountHeaderSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 30
        let layoutHeaderSection = createCategoryHeaderSection()
    
        layoutSection.boundarySupplementaryItems = [layoutHeaderSection]
        
        return layoutSection
    }
    
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .estimated(80))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
    
    
    func setNavigationBar() {
                
        self.navigationItem.setHidesBackButton(true, animated:false)
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        
        let iconImage = UIImageView(frame: CGRect(x: 0, y: 10, width: 50, height: 50))
        
        iconImage.image = UIImage(systemName: "line.3.horizontal")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        

        let labelOne: UILabel = {
            
            let labelOne = UILabel()
            labelOne.text = "Settings"
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


extension SettingViewController:  WarmodroidSwitchDelegate  {
    
    func didTapSwitch(isON: Bool) {
        print(isON)
    }
    
}
