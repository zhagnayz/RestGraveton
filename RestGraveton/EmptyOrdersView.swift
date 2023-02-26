//
//  EmptyOrdersView.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit

class EmptyOrdersView: UIView {

    var collectionView: UICollectionView!
    
    enum Sections: Int {
        
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
   
        self.backgroundColor = .yellow
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: compositinLayout())
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        collectionView.register(AccountHeaderCell.self, forCellWithReuseIdentifier: AccountHeaderCell.reuseIdentifier)
        
        collectionView.register(TitleSubAndButtonsCell.self, forCellWithReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        self.addSubview(collectionView)

        createDataSource()
        reloadData()
    }
    
    func createDataSource(){

        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in

            switch indexPath.section {

            case Sections.sectionOne.rawValue:

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountHeaderCell.reuseIdentifier, for: indexPath) as? AccountHeaderCell else {fatalError("Unable to dequeue")}
//
                cell.logoImageView.image = UIImage(systemName: "circle.slash")
                cell.logoLabel.text = "No Active Orders"
                cell.subTitle.text = "Check to see if your tablet is working properly\n by creating a test order on the Settings page"
                
//                cell.imageView.image = UIImage(systemName: "bag")
//                cell.inFoLabel.text = "No Active Orders"
//                cell.instructLabel.text = "Check to see if your tablet is working properly\n by creating a test order on the Settings page"

                return cell

            case Sections.sectionTwo.rawValue:

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier, for: indexPath) as? TitleSubAndButtonsCell else {fatalError("Unable to dequeue")}

                cell.inFoLabel.text = "Prevent order issues from happening"
                cell.instructLabel.text = "Pay attention to items with the tag below to\n reduce commonly reported customer issues"

                return cell

            case Sections.sectionThree.rawValue:

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError("Unable to dequeue")}

                cell.name.text = "Double check this item - Often Missing"
                cell.iconImageView.image = UIImage(systemName: "bag")
                cell.backgroundColor = .systemRed
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 6
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }

    func reloadData(){

        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()

        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree])
        snapShot.appendItems([""],toSection: Sections.sectionOne)
        snapShot.appendItems(["dafs"], toSection: Sections.sectionTwo)
        snapShot.appendItems(["ddddd"], toSection: Sections.sectionThree)

        dataSource?.apply(snapShot)
    }

    func compositinLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout {

            sectionIndex, layoutEnvironment in

            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}

            switch section {

            case .sectionOne: return self.ViewEmptyDataSecion()

            case .sectionTwo: return self.EmptyDataSecion()
                
            case .sectionThree: return self.ButttonSecion()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()

        config.interSectionSpacing = 30

        layout.configuration = config

        return layout
    }

    func ViewEmptyDataSecion() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: self.frame.size.height/4, leading: 0, bottom: 0, trailing: 10)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))

        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        return layoutSection
    }

    func EmptyDataSecion() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 20, bottom: 25, trailing: 20)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))

        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        return layoutSection
    }
    
    func ButttonSecion() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 200, bottom: 25, trailing: 200)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))

        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        return layoutSection
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

