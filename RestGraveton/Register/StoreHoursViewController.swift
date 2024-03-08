//
//  StoreHoursViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 7/15/23.
//

import UIKit
import FirebaseFirestore

class StoreHoursViewController: UIViewController{
    
    var iconMenuTop = [IconMenu(icon: "note.text", name: "Apply same hours to all")]
    var buttonTitle = ["Continue"]
    private var dateString:[String] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    private var generalInfo = Information(title: "When are you open for business?", subTitle: "When will accept your last order 20 mins before you close. So that you have enough time to prepare the food.")
    
    private var storeHours:[String] = []
    var businessInfo: [String:Any] = [:]
    var bankInfos: [String:Any] = [:]
    private var displayDay:[String] = []
    var uid:String?
 
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectonThree
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayDay = dateString
   
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        view.addSubview(collectionView)
                
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.reuseIdentifier)
        
        collectionView.register(StoreHoursCell.self, forCellWithReuseIdentifier: StoreHoursCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)

        collectionView.delegate = self
        createDataSource()
        reloadData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action:nil)
    }

    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {fatalError()}
                
                cell.configureCell(item as? IconMenu)
                
                cell.warmodroidSwitch.delegate = self

                return cell
            
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreHoursCell.reuseIdentifier, for: indexPath) as? StoreHoursCell else {fatalError()}
           
                cell.dateLabel.text = item as? String
                
                return cell
                
            case Sections.sectonThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError()}
                
                cell.name.text = item as? String
                cell.backgroundColor = .white
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = cell.frame.size.height/2
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.title.text = self?.generalInfo.title
            sectionHeader.info.text =  self?.generalInfo.subTitle
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectonThree])
        
        snapShot.appendItems(iconMenuTop,toSection: .sectionOne)
        snapShot.appendItems(displayDay,toSection: .sectionTwo)
        snapShot.appendItems(buttonTitle,toSection: .sectonThree)

        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
            
            case .sectionOne: return self.createOnButton()
            case .sectionTwo: return self.createProteinSection()
            case .sectonThree: return self.createButtonssSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 60
        layout.configuration = config
        
        return layout
    }
    
    func createProteinSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 200, bottom: 0, trailing: 200)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        layoutGroup.interItemSpacing = .fixed(30)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createOnButton() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 100, bottom: 0, trailing: 100)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.interGroupSpacing = 6
        
        let layoutHeaderSection = createCategoryHeaderSection()
        
        layoutSection.boundarySupplementaryItems = [layoutHeaderSection]
        
        return layoutSection
    }
    
    func createButtonssSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 200, bottom: 0, trailing: 200)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.interGroupSpacing = 6
        
        return layoutSection
    }
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .estimated(80))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
    
    @objc func didTapReadTimeButton(){
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item: item, section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! StoreHoursCell
            
            switch item {
                
            case 0: getHourAndMinute(cell.leftDatePicker.date, cell.rightDatePicker.date, cell.dateLabel.text!,cell.ifCheckmakclose)
                
            case 1: getHourAndMinute(cell.leftDatePicker.date, cell.rightDatePicker.date, cell.dateLabel.text!,cell.ifCheckmakclose)
                
            case 2: getHourAndMinute(cell.leftDatePicker.date, cell.rightDatePicker.date, cell.dateLabel.text!,cell.ifCheckmakclose)
                
            case 3: getHourAndMinute(cell.leftDatePicker.date, cell.rightDatePicker.date, cell.dateLabel.text!,cell.ifCheckmakclose)
                
            case 4: getHourAndMinute(cell.leftDatePicker.date, cell.rightDatePicker.date, cell.dateLabel.text!,cell.ifCheckmakclose)
                
            case 5: getHourAndMinute(cell.leftDatePicker.date, cell.rightDatePicker.date, cell.dateLabel.text!,cell.ifCheckmakclose)
                
            case 6: getHourAndMinute(cell.leftDatePicker.date, cell.rightDatePicker.date, cell.dateLabel.text!,cell.ifCheckmakclose)
                
            default: cell.backgroundColor = .white
            }
        }
    }
    
    func getHourAndMinute(_ leftDate:Date,_ rightDate:Date,_ weedDay:String,_ isOpen:Bool){
        
        let leftComponents = Calendar.current.dateComponents([.hour, .minute], from: leftDate)

        let hour = leftComponents.hour
        let minute = leftComponents.minute
    
        let rightComponents = Calendar.current.dateComponents([.hour, .minute], from: rightDate)

        let righthour = rightComponents.hour
        let rightminute = rightComponents.minute
        
        if isOpen {
            let time = "\(weedDay) close"
            self.storeHours.append(time)
                    
        }else{
            let time = "\(hour!):\(minute!) - \(righthour!):\(rightminute!) \(weedDay) open"
            self.storeHours.append(time)
        }
    }
}

extension StoreHoursViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.item == 0 {
            
            didTapReadTimeButton()
            
            registerUserIntoDatabase()
            
            let taskVC =  UINavigationController(rootViewController: ViewController())
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(taskVC)
            
            UserDefaults.standard.set(storeHours, forKey: "storeHours")
        }
    }
    
    func registerUserIntoDatabase(){
        
        CameraManager.shared.stringUID = uid

        let databse = Firestore.firestore()

        let dataToSave:[String:Any] = ["businInfo":businessInfo,"storeHours":storeHours,"bankInfo":bankInfos]
        
        if let uid = uid {
            
            let collDocument = databse.collection("Parners").document(uid)
            
            collDocument.setData(dataToSave)
        }
    }
}

extension StoreHoursViewController: WarmodroidSwitchDelegate {
    
    func didTapSwitch(isON: Bool) {
        
        storeHours = []
        
        if isON  {
            displayDay = ["Mon-Sun"]
        }else{
            displayDay = dateString
        }
        self.reloadData()
    }
}
