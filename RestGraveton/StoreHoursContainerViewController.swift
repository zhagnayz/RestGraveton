//
//  StoreHoursContainerViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import UIKit


class StoreHoursContainerViewController: UIViewController {
    
    var information = [Information(title: "Regular Menu Hours", subTitle: "These are the hours your store available on Graveton")]
    
    var dateAvailabe:[String] = []
        
    var policyString:String?
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    var collectionView: UICollectionView!
        
    let  secondStoreHoursView =  SecondStoreHoursView()
    
    var restInfo: Information?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let storeHours = UserDefaults.standard.array(forKey: "storeHours"){
            dateAvailabe = storeHours as? [String] ?? []
        }else{
            dateAvailabe = ["No Data Available"]
        }
        
        if let data = UserDefaults.standard.object(forKey: "restInfo") as? Data{
            let decodedData = try? JSONDecoder().decode(Information.self, from: data)
            restInfo = decodedData
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositinLayout())
        
        collectionView.register(TitleSubAndButtonsCell.self, forCellWithReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(DataInfoCell.self, forCellWithReuseIdentifier: DataInfoCell.reuseIdentifier)
        
        if let _ = policyString {
            view.addSubview(collectionView)
        }else{
            let stackView = UIStackView(arrangedSubviews: [collectionView,secondStoreHoursView.collectionView])
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 1
            
            view.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.topAnchor.constraint(equalTo: view.topAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.widthAnchor.constraint(equalToConstant: 300)
            ])
            
            setNavigationBar()
        }

        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in
            
            if let information = item as? Information {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier, for: indexPath) as? TitleSubAndButtonsCell else {fatalError(TitleSubAndButtonsCell.reuseIdentifier)}
                cell.configureCell(information)
                
                return cell
            }else if let dateAvailabe = item as? IconMenu {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataInfoCell.reuseIdentifier, for: indexPath) as? DataInfoCell else {fatalError(DataInfoCell.reuseIdentifier)}
    
                cell.configure(dateAvailabe)
                
                return cell
            }else if let policyString = item as? String {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataInfoCell.reuseIdentifier, for: indexPath) as? DataInfoCell else {fatalError()}
                
                cell.name.numberOfLines = 0
                cell.name.text = policyString
                
                return cell
            }else{
               return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.separator.backgroundColor = .clear
            let info = "\(self.restInfo?.title ?? "") \(self.restInfo?.subTitle ?? "")"
            sectionHeader.title.text = info
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        defer{dataSource?.apply(snapShot)}
        
        guard let policyString = policyString else {
            
            snapShot.appendSections([.sectionOne,.sectionTwo])
            snapShot.appendItems(information,toSection: .sectionOne)
            snapShot.appendItems(dateAvailabe, toSection: .sectionTwo)
            
            return
        }
        
        snapShot.appendSections([.sectionThree])
        snapShot.appendItems([policyString],toSection:.sectionThree)
    }
    
    func compositinLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
        
            if let _ = self.policyString {
                return self.createPolicySection()
            }
            
            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
                
            case .sectionOne: return self.CreateInfoSecion()
            case .sectionTwo:return self.createPolicySection()
            case .sectionThree:return self.createPolicySection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    func createPolicySection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func CreateInfoSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutHeaderSection = createOrderHeaderSection()
        layoutSection.boundarySupplementaryItems = [layoutHeaderSection]
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top:20, leading: 0, bottom: 0, trailing: 0)

        return layoutSection
    }
    
    func createOrderHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(80))
        
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
            labelOne.text = "store hours"
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
