//
//  RegisterViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 7/13/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    var bussinessInfo = PersonInfo()
    
    private lazy var showOrHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("show", for: .normal)
        button.addTarget(self, action: #selector(didTapHideOrShowButton), for: .touchUpInside)
        return button
    }()
    
    var number: String = ""
    var businessInfo: [String:Any] = [:]
    var uid:String?
    
    var SignUpplaceHolder = ["First Name","Last Name","Email","Phone","Create Password"]
    
    var buttonTitle = ["Continue"]
    
    private var dataString:[String] = ["Account Number","Routing Number","Legal Business Name","Restaurant Type","EIN/Tax ID Number","Legal Name","Date of Birth"]
    
    private var displayData:[String] = []
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        view.addSubview(collectionView)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else {fatalError(TextFieldCell.reuseIdentifier)}
                
                cell.placeHolderr = item as? String
                cell.textField.delegate = self
                if indexPath.item == 2 {
                    cell.textField.text = self.bussinessInfo.phone
                }else if indexPath.item == 3 {
                    cell.textField.text = self.bussinessInfo.password
                    cell.textField.keyboardType = .numberPad
                }else if indexPath.item == 4 {
                    
                    cell.textField.isSecureTextEntry = true
                    cell.textField.rightViewMode = .always
                    cell.textField.rightView = self.showOrHideButton
                }
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else {fatalError()}
                
                cell.placeHolderr = item as? String
                cell.textField.delegate = self
                
                if indexPath.item == 6{
                    cell.textField.keyboardType = .numberPad
                }
                
                return cell
            case Sections.sectionThree.rawValue:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError(ButtonCell.reuseIdentifier)}
                
                cell.name.text = item as? String
                
                cell.backgroundColor = .white
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.title.text = "Add your bank account information so you can get paid"
            sectionHeader.info.text = "This information is secure and we will never withdraw from this account."
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree])
        
        snapShot.appendItems(SignUpplaceHolder,toSection: .sectionOne)
        snapShot.appendItems(displayData,toSection: .sectionTwo)
        snapShot.appendItems(buttonTitle,toSection: .sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createTextFieldsSection()
            case .sectionTwo: return self.createProteinSection()
            case .sectionThree: return  self.createTextFieldsSection()
            }
        }
        return layout
    }
    
    func createTextFieldsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top:30, leading:250, bottom:0, trailing:250)
        return layoutSection
    }
    
    func createProteinSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 200, bottom: 0, trailing: 200)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        layoutGroup.interItemSpacing = .fixed(30)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        if displayData.count > 1 {
            let layoutHeaderSection = createCategoryHeaderSection()
            layoutSection.boundarySupplementaryItems = [layoutHeaderSection]
        }
        return layoutSection
    }
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .estimated(80))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
    
    @objc func didTapBackButton(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTapContinueButton(){
        
        var personInfo = PersonInfo()
        
        for item in 0..<collectionView.numberOfItems(inSection: 0){
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            switch item {
                
            case 0:personInfo.firstName = cell.textField.text!
            case 1:personInfo.lastName = cell.textField.text!
            case 2:personInfo.email = cell.textField.text!.trimmingCharacters(in: .whitespaces)
            case 3:personInfo.phone = cell.textField.text!
            case 4:personInfo.password = cell.textField.text!
                
            default: cell.backgroundColor = .white
            }
        }
        
        if let firstName = personInfo.firstName,firstName.count > 0,let lastName = personInfo.lastName, lastName.count > 0,let emal = personInfo.email,emal.count > 0,let phone = personInfo.phone,phone.count > 0,let password = personInfo.password,password.count > 0 {
            
            allowLoginIn(personInfo)
        }else{
            self.navigationItem.titleView = getNofiticiationView("Fill require fields", isError: true)
        }
    }
    
    func allowLoginIn(_ personInfo:PersonInfo){
        
        let name = personInfo.firstName! + " " + personInfo.lastName!
        
        let params:[String:Any] = ["persoName": name,"email":personInfo.email!,"phone":personInfo.phone!,"busiType":bussinessInfo.fullName!,"busiName":bussinessInfo.firstName!,"busiAddress":bussinessInfo.lastName!,"linkMenu":bussinessInfo.email!,"BusiEmail":bussinessInfo.phone!,"BusiPhone":bussinessInfo.password!]
        
        Auth.auth().createUser(withEmail: personInfo.email!, password: personInfo.password!) { result, error in
            
            if let error = error {
                self.navigationItem.titleView = getNofiticiationView(error.localizedDescription, isError: true)
                return
            }
            
            self.uid = result?.user.uid
            self.businessInfo = params
            self.displayNewData()
        }
    }
    
    func displayNewData(){
        self.SignUpplaceHolder = []
        self.displayData = self.dataString
        self.reloadData()
    }
    
    @objc func didTapOutsideOfTextField(){
        view.endEditing(true)
    }
    
    @objc func didTapHideOrShowButton(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        
        let cell = collectionView.cellForItem(at: IndexPath(item: 4, section: 0)) as? TextFieldCell
        
        cell?.textField.isSecureTextEntry = sender.isSelected
        
        if sender.isSelected {
            showOrHideButton.setTitle("show", for: .normal)
        }else{
            showOrHideButton.setTitle("hide", for: .normal)
        }
        reloadData()
    }
    
    @objc func readDataInfo(){
        
        var userAccountInfo = PersonInfo()
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item: item, section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            switch item {
                
            case 0:userAccountInfo.firstName = cell.textField.text!
            case 1:userAccountInfo.lastName = cell.textField.text!
            case 2:userAccountInfo.email = cell.textField.text!
            case 3:userAccountInfo.phone = cell.textField.text!
            case 4:userAccountInfo.password = cell.textField.text!
            case 5:userAccountInfo.fullName = cell.textField.text!
            case 6:userAccountInfo.midName = cell.textField.text!
                
            default: cell.backgroundColor = .white
            }
        }
        
        if let accountNum = userAccountInfo.firstName,accountNum.count > 0,let routingNum = userAccountInfo.lastName,routingNum.count > 0,let busiName = userAccountInfo.email,busiName.count > 0,let busiType = userAccountInfo.phone,busiType.count > 0,let EINTAXID = userAccountInfo.password,EINTAXID.count > 0,let legalName = userAccountInfo.fullName,legalName.count > 0,let dfb = userAccountInfo.midName,dfb.count > 0 {
            
            let bankInfos:[String:String] = ["accountNum":accountNum,"routingNum":routingNum,"businName":busiName,"businType":busiType,"EINTAXID":EINTAXID,"legalName":legalName,"dateOfBirth":dfb]
            
            let storeHoursVC = StoreHoursViewController()
            storeHoursVC.uid = self.uid
            storeHoursVC.businessInfo = businessInfo
            storeHoursVC.bankInfos = bankInfos
            navigationController?.pushViewController(storeHoursVC, animated: false)
            
        }else{
            self.navigationItem.titleView = getNofiticiationView("Fill require fields", isError: true)
        }
    }
}

extension RegisterViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.item == 0 {
            
            if let uid = uid, uid.count > 0 {
                readDataInfo()
            }else{
                didTapContinueButton()
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
