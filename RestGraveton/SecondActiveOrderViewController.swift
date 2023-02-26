//
//  SecondActiveOrderViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit

class SecondActiveOrderViewController: UIViewController{
    
    var user: User = User(){
        didSet{
            setNavigationBar()
        }
    }
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var selectedIndex: Int?
    
    lazy var buttonTitle = "Order ready for pickup"
    lazy var buttonTitleMarkAsReadyPickUp = "Marked as ready for pick up"
    
    lazy var buttonTitlechange = buttonTitleMarkAsReadyPickUp
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    var emptyOrdersView = EmptyOrdersView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(user)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(collectionView)
        
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        
        collectionView.delegate = self
        
        setNavigationBar()
        createDataSource()
        
        reloadData()
        
        //        let stackView = UIStackView(arrangedSubviews: [emptyOrdersView])
        //
        //        stackView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        view.addSubview(stackView)
        //
        //        NSLayoutConstraint.activate([
        //
        //            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        //            stackView.topAnchor.constraint(equalTo: view.topAnchor),
        //            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        //            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        //        ])
    }
    
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell else {fatalError()}
                
                guard let order = self.user.order else {fatalError()}
                
                cell.quantityLabel.text = "\(order.items[indexPath.item].quantity)"
                cell.itemNameLabel.text = order.items[indexPath.item].name
                cell.itemPriceLabel.text = "\(order.items[indexPath.item].formattedTotalPrice)"
                
                if let order = self.user.order {
                    
                    for item in order.items[indexPath.item].foodIngredient {
                        
                        cell.itemDetailsLabel.text = item.ingredient[indexPath.item].name
                    }
                }
                
                cell.extraDetailLabel.text = "Blasamic Vinagrette ($0.50)"
                cell.arrowButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError()}
                
                let isSelected = self.selectedIndex == indexPath.item
                
                cell.isSelected(isSelected)
                
                cell.name.text = self.buttonTitlechange
                
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        
        snapShot.appendItems(["dfs"], toSection: Sections.sectionOne)
        
        snapShot.appendItems(["dd"],toSection: Sections.sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            
            sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case Sections.sectionOne: return self.createMenuItemSection()
                
            case .sectionTwo: return self.createSingleSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 100
        
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
    
    func createSingleSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
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
            labelOne.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            labelOne.text = user.order?.reference
            
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
        stackViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackViewOne.spacing = 2
        
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
            stackViewOne.widthAnchor.constraint(equalToConstant: 115),
        ])
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
    }
}

extension SecondActiveOrderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.item == 0{
            
            self.selectedIndex = indexPath.item
            self.buttonTitlechange = buttonTitle
        }
        
        collectionView.reloadData()
    }
}

extension SecondActiveOrderViewController: inputDataDelegate {
    
    func getData(_ user: User) {
        self.user = user
        collectionView.reloadData()
    }
}
