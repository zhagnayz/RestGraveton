//
//  RegisterBusinViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 7/13/23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseStorage
import CoreLocation

class RegisterBusinViewController: UIViewController {
    
    var policyString = "By tapping Continue with Email or Google, you agree to Graveton's Terms & Conditions and Pricacy Policy."
    
    var SignUpplaceHolder = ["Business Name","Business Address","link Menu","Email Address","Phone Number"]
    
    var businessTypeIcon = [IconMenu(icon: "square.2.layers.3d.top.filled", name: "Select business type")]
    
    var iconMenu = [IconMenu(icon: nil, name: "Continue", subName: nil),IconMenu(icon:"google", name: "Continue with Google")]
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
        case sectionFour
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        view.addSubview(collectionView)
        
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        collectionView.register(TitleSubAndButtonsCell.self, forCellWithReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier)
        
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
                
                if indexPath.item == 4 {
                    cell.textField.keyboardType = .numberPad
                }
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {fatalError()}
                
                cell.configureCell(item as? IconMenu)
                
                if indexPath.item == 0{
                    cell.buttonPanelView.isHidden = false
                    cell.warmodroidSwitch.isHidden = true
                    cell.buttonPanelView.dogButton.setTitle("Restaurant", for: .normal)
                    cell.buttonPanelView.catButton.setTitle("Food Truck", for: .normal)
                    cell.label.isHidden = !cell.label.isHidden
                }
                
                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError()}
                
                cell.configureCell(item as? IconMenu)
                
                cell.backgroundColor = .white
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = cell.contentView.frame.size.height/2
                return cell
                
            case Sections.sectionFour.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSubAndButtonsCell.reuseIdentifier, for: indexPath) as? TitleSubAndButtonsCell else {fatalError()}
                
                cell.instructLabel.textColor = .white
                cell.instructLabel.setDifferentColor(string: self.policyString, location: 65, length: 38)
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree,.sectionFour])
        
        snapShot.appendItems(SignUpplaceHolder,toSection: .sectionOne)
        snapShot.appendItems(businessTypeIcon,toSection: .sectionTwo)
        snapShot.appendItems(iconMenu,toSection: .sectionThree)
        snapShot.appendItems([policyString],toSection: .sectionFour)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createTextFieldsSection()
            case .sectionTwo: return self.createButtonType()
            case .sectionThree: return self.createTextFieldsSection()
            case .sectionFour: return self.createTextFieldsSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    func createTextFieldsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top:0, leading:250, bottom:0, trailing:250)
        return layoutSection
    }
    
    func createButtonType() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 150, bottom: 0, trailing: 150)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    @objc func didTapBackButton(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTapContinueButton(_ item:Int){
        
        var personInfo = PersonInfo()
        
        for item in 0..<collectionView.numberOfItems(inSection: 0){
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            switch item {
                
            case 0:personInfo.firstName = cell.textField.text!
            case 1:personInfo.lastName = cell.textField.text!
            case 2:personInfo.email = cell.textField.text!
            case 3:personInfo.phone = cell.textField.text!
            case 4:personInfo.password = cell.textField.text!
                
            default: cell.backgroundColor = .white
            }
        }
        
        let Seccell = collectionView.cellForItem(at: IndexPath(item: 0, section: 1)) as! SettingCell
        personInfo.fullName = Seccell.label.text
        
        saveRestInfo(personInfo.firstName!, restAddress: personInfo.lastName!)
        
        guard personInfo.firstName != nil,personInfo.lastName != nil,personInfo.email != nil,personInfo.phone != nil,personInfo.password != nil,personInfo.fullName != nil else {
            
            self.navigationItem.titleView = getNofiticiationView("Fill require fields", isError: true)
            return
        }
        
        if item == 0 {
            saveToDataBase(personInfo)
        }else if item == 1 {
            didTapContinueWithGoogleButton(personInfo)
        }
    }
    
    func saveToDataBase(_ personInfo:PersonInfo){
        
        let registerVC = RegisterViewController()
        registerVC.bussinessInfo  = personInfo
        
        navigationController?.pushViewController(registerVC, animated: false)
    }
    
    func didTapContinueWithGoogleButton(_ personInfo:PersonInfo){
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {result, error in
            
            guard let user = result?.user,let idToken = user.idToken?.tokenString else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                
                if let _ = error{return}
                
                UserDefaults.standard.set(result?.user.uid, forKey: "uid")
                
                let registerVC = RegisterViewController()
                
                if let result = result {
                    
                    let params:[String:Any] = ["persoName": result.user.displayName!,"email":result.user.email!,"phone":personInfo.password!,"busiType":personInfo.fullName!,"busiName":personInfo.firstName!,"busiAddress":personInfo.lastName!,"linkMenu":personInfo.email!]
                    
                    registerVC.businessInfo = params
                    registerVC.uid = result.user.uid
                    registerVC.displayNewData()
                    
                    let vc =  UINavigationController(rootViewController: registerVC)
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                    
                    return
                }
            }
        }
    }
    
    func saveRestInfo(_ restName:String,restAddress:String){
        
        CLGeocoder().geocodeAddressString(restAddress) { placemarks, error in
            
            if let placemark = placemarks?.first {
                
                let place = placemark.locality
                
                if let place = place {
                    
                    let inform = Information(title: restName, subTitle: place)
                    
                    do{
                        let encodedInform = try? JSONEncoder().encode(inform)
                        
                        UserDefaults.standard.set(encodedInform, forKey: "restInfo")
                    }
                }
            }
        }
    }
    
    @objc func didTapOutsideOfTextField(){
        view.endEditing(true)
    }
}

extension RegisterBusinViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.item == 0 {
            didTapContinueButton(indexPath.item)
        }else if indexPath.section == 2 && indexPath.item == 1{
            didTapContinueButton(indexPath.item)
        }else if indexPath.section == 3 && indexPath.item == 0 {
            showPolicyVC()
        }
    }
    
    func showPolicyVC(){
        
        let storageRef = Storage.storage().reference(withPath: "policy")
        
        storageRef.getData(maxSize:17065) { data, error in
            
            if let data = data {
                
                let decodedData =  try? JSONDecoder().decode(Policy.self, from: data)
                
                let storeHoursVC = StoreHoursContainerViewController()
                
                storeHoursVC.policyString = decodedData?.policy
                
                self.present(storeHoursVC, animated: false)
            }
        }
    }
    
    @objc func didTapBackXButton(){
        dismiss(animated: true)
    }
}

extension RegisterBusinViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
