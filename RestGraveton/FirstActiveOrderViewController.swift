//
//  FirstActiveOrderViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit

class FirstActiveOrderViewController: UIViewController {
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var user: [User] = []
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    var isSelectedButton: Bool = false
    var defaultHighlightedCell: Int = 0
    weak var delegate: inputDataDelegate?
    
    var counter = 15
    
    var cellItemToTimerMapping: [Int: Timer] = [:]
    var cellItemToPauseFlagMapping: [Int: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        user = IpadDataManager.shared.user
        
        DispatchQueue.main.async {
            
            let defaultRow = IndexPath(item: self.defaultHighlightedCell, section: 0)
            self.collectionView.selectItem(at: defaultRow, animated: false, scrollPosition: .bottom)
        }
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(ClientInfoCell.self, forCellWithReuseIdentifier: ClientInfoCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
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
                
                let myCustomSelectionColorView = UIView()
                myCustomSelectionColorView.backgroundColor = .secondarySystemBackground
                cell.selectedBackgroundView = myCustomSelectionColorView
                
                self.setupTimer(for: cell, indexPath: indexPath)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError("Unable to Deque \(ButtonCell.reuseIdentifier)")}
                
                cell.name.text = "See history"
                cell.backgroundColor = .tertiarySystemGroupedBackground
                
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.title.text = "IN THE KITCHEN"
            sectionHeader.requiredAndOptionalButton.setTitle("\(self.user.count) order", for: .normal)
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        
        snapShot.appendItems(user,toSection: Sections.sectionOne)
        
        snapShot.appendItems(["dd"],toSection: Sections.sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            
            sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case Sections.sectionOne: return self.createClientInfosSection()
                
            case .sectionTwo: return self.createSingleSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        layout.configuration = config
        
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
    
    func createSingleSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .estimated(80))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
    
    private func setupTimer(for cell: UICollectionViewCell, indexPath: IndexPath) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        
        let item = indexPath.item
        
        if cellItemToTimerMapping[item] == nil {
            
            var numberOfSecondsPassed = 10
            
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { capturedTimer in
                
                if self.cellItemToPauseFlagMapping[item] != nil && self.cellItemToPauseFlagMapping[item] == true {return}
                                
                numberOfSecondsPassed -= 1
                
                let visibleCell = self.collectionView.cellForItem(at: indexPath) as? ClientInfoCell

                if let visibleCell = visibleCell {
                    
                    visibleCell.readyPickUpLabel.text = "\(String(numberOfSecondsPassed))"
                }

                if numberOfSecondsPassed == 0 {
                    numberOfSecondsPassed = 10
                            self.cellItemToPauseFlagMapping[item] = true
                    if let visibleCell = visibleCell {
                        
                        let date = "\(dateFormatter.string(from: Date()))"
                        visibleCell.readyPickUpLabel.text = date
                    }
                    self.makeNetworkCall {
                        self.cellItemToPauseFlagMapping[item] = true
                    }
                    
                    self.user[item].order?.date = "\(dateFormatter.string(from: Date()))"
                    
                    IpadDataManager.shared.userData.userHistory.append(self.user[item])
                    IpadDataManager.shared.user.remove(at: 0)
                }
            }
            
            cellItemToTimerMapping[item] = timer
            RunLoop.current.add(timer, forMode: .common)
            
        }
    }
    private func makeNetworkCall(completion: @escaping () -> Void) {
         let seconds = 2.0
         DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
             completion()
             
             
         }
     }
    
//    @objc func updateCounter(_ timer: Timer) {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
//
//        for item in 0..<collectionView.numberOfItems(inSection: 0){
//
//            let indexPath = IndexPath(item: item, section: 0)
//
//            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as? ClientInfoCell
//
//            switch item {
//            case 0:
//                if counter > 0 {
//
//                    if let visibleCell = cell {
//                        visibleCell.readyPickUpLabel.text = "ready in \(counter)"
//                    }
//                    counter -= 1
//                }else {
//
//                    timer.invalidate()
//
//                    let date = "\(dateFormatter.string(from: Date()))"
//
//                    if let visibleCell = cell {
//
//                        visibleCell.readyPickUpLabel.text = date
//                    }
//                }
//            case 1:
//                if counter > 0 {
//
//                    if let visibleCell = cell {
//                        visibleCell.readyPickUpLabel.text = "ready in \(counter)"
//                    }
//                    counter -= 1
//                }else {
//
//                    timer.invalidate()
//
//                    let date = "\(dateFormatter.string(from: Date()))"
//
//                    if let visibleCell = cell {
//
//                        visibleCell.readyPickUpLabel.text = date
//                    }
//                }
//            default:
//                cell?.backgroundColor = .white
//            }
//        }
//    }
    
    func didTapSeeHistoryButton(){
        
        NotificationCenter.default.post(name: NSNotification.Name("com.user.history"), object: nil)
    }
}

extension FirstActiveOrderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let selectedUser = user[indexPath.item]
            delegate?.getData(selectedUser)
        }
        
        if indexPath.section == 1 {
            didTapSeeHistoryButton()
        }
    }
}
