//
//  SignInViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 7/13/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {
    
    var iconMenu = [IconMenu(icon: nil, name: "Continue", subName: nil),IconMenu(icon:  "google", name: "Continue with Google")]
    
    var placeHolder = ["email","password"]
    
    var hideOrShowClick = true
    
    private lazy var showOrHideButton: UIButton = {
        let button = UIButton(frame: CGRect())
        button.setTitle("show", for: .normal)
        button.addTarget(self, action: #selector(didTapHideOrShowButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var ReigsterButton: UIButton = {
        let button = UIButton(frame: CGRect())
        button.setTitle("Register Now", for: .normal)
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = imageView
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ReigsterButton)
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        view.addSubview(collectionView)
        
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
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else {fatalError()}
                
                cell.placeHolderr = item as? String
                cell.textField.delegate = self
                
                if indexPath.item == 1{
                    
                    cell.textField.isSecureTextEntry = true
                    cell.textField.rightViewMode = .always
                    cell.textField.rightView = self.showOrHideButton
                }
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError()}
                
                cell.backgroundColor = .white
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = cell.frame.size.height/2
                
                cell.configureCell(item as? IconMenu)
                return cell
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo])
        
        snapShot.appendItems(placeHolder,toSection: .sectionOne)
        snapShot.appendItems(iconMenu,toSection: .sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createTextFieldsSection()
            case .sectionTwo: return self.createTextFieldsSection()
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
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top:60, leading:250, bottom:0, trailing:250)
        return layoutSection
    }
    
    @objc func didTapRegisterButton(){
        showRegisterVC()
    }
    
    func didTapLoginButton(){
        
        var email: String = ""
        var password: String = ""
        
        for item in 0..<collectionView.numberOfItems(inSection: 0){
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            switch item {
                
            case 0: email = cell.textField.text!.trimmingCharacters(in: .whitespaces)
            case 1: password = cell.textField.text!
                
            default: cell.backgroundColor = .white
            }
        }
        LoginInToFirebaseDatabase(email, password)
    }
    
    func didTapContinueWithGoogleButton(){
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        
        if let _ = uid {
            
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
                
                guard let user = result?.user,let idToken = user.idToken?.tokenString else {return}
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                Auth.auth().signIn(with: credential) { result, error in
                    
                    if let error = error{self?.navigationItem.title = error.localizedDescription
                        return}
                    
                    CameraManager.shared.stringUID = result?.user.uid
                    self?.showVC()
                    return
                }
            }
        }else{
            showRegisterVC()
        }
    }
    
    func showRegisterVC(){
        let regiserVC = RegisterBusinViewController()
        navigationController?.pushViewController(regiserVC, animated: false)
    }
    
    func showVC(){
        let navVC = UINavigationController(rootViewController: ViewController())
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navVC)
    }
    
    func LoginInToFirebaseDatabase(_ email:String,_ password:String){
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                self.navigationItem.titleView = getNofiticiationView(error.localizedDescription, isError: true)
                
                return
            }
            
            CameraManager.shared.stringUID = result?.user.uid
            self.showVC()
        }
    }
    
    @objc func didTapHideOrShowButton(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        
        let indexPath = IndexPath(item: 1, section: 0)
        
        let cell = collectionView.cellForItem(at: indexPath) as? TextFieldCell
        
        cell?.textField.isSecureTextEntry = sender.isSelected
        
        if sender.isSelected {
            showOrHideButton.setTitle("show", for: .normal)
        }else{
            showOrHideButton.setTitle("hide", for: .normal)
        }
        reloadData()
    }
}

extension SignInViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.item == 0 {
            didTapLoginButton()
        }else if indexPath.section == 1 && indexPath.item == 1 {
            didTapContinueWithGoogleButton()
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
