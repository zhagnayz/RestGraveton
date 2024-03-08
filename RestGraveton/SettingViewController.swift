//
//  SettingViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class SettingViewController: UIViewController {
    
    var iconMenu = [IconMenu(icon: "bolt.fill", name: "Auto-confirm new Orders"),IconMenu(icon:"bell.fill", name: "New order alert volume"),
                                IconMenu(icon: "bag.fill", name: "Create test order"),IconMenu(icon: "bolt.fill", name: "Alert when Graveton Driver is arriving")]
    
    enum Sections: Int {
        case sectionOne
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositinLayout())
        
        view.addSubview(collectionView)
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        setNavigationBar()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {fatalError()}
                
                cell.configureCell(item as? IconMenu)
                
                cell.warmodroidSwitch.delegate = self
                
                if indexPath.item == 1 {
                    
                    cell.warmodroidSwitch.isHidden = !cell.warmodroidSwitch.isHidden
                    cell.buttonPanelView.isHidden = !cell.buttonPanelView.isHidden
                    cell.label.isHidden = !cell.label.isHidden
                    
                    cell.buttonPanelView.completion = {item in
                        self.isQuietOrLoud(item.rawValue)
                    }
                }
                
                if indexPath.item == 2 {
                    
                    cell.warmodroidSwitch.isHidden = true
                    cell.label.isHidden = false
                }
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func isQuietOrLoud(_ item:Int){
        
        if item == 0 {
            CameraManager.shared.isQuietOrLoud = true
        }else if item == 1 {
            CameraManager.shared.isQuietOrLoud = false
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne])
        
        snapShot.appendItems(iconMenu,toSection: .sectionOne)
        
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
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 30
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 10, bottom: 0, trailing: 10)
        
        return layoutSection
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
            labelOne.text = "settings"
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
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SettingViewController:  WarmodroidSwitchDelegate  {
    
    func didTapSwitch(isON: Bool) {}
}
