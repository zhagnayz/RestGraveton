//
//  OrderHistoryContainerViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/22/23.
//

import UIKit
import FirebaseFirestore

class OrderHistoryContainerViewController: UIViewController {
    
    let databse = Firestore.firestore()

    let secondVC = SecondOrderHistoryViewController()
    
    enum Sections: Int {
        case sectionOne
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    var defaultHighlightedCell: Int = 0
    
    weak var delegate: inputDataDelegate?
    
    var users: [User] = [User]()
    
    private var fileManager = FileManager.default
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .gray
        label.text = "No records found"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lineView: UILabel = {
        let lineView = UILabel()
        lineView.backgroundColor = .gray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    var total:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = CameraManager.shared.stringUID {
            let collDocument = databse.collection("Parners").document(uid)
            
            collDocument.getDocument { document, error in
                
                if let document = document {
                    
                    let data = document.data()
                    
                    self.total = "Total sale \(String(format: "$%.2f",data?["amount"] as? Double ?? 0.0))"
                }
            }
        }
        
        retrieveData()
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        if users.count > 0 {
            secondVC.order = users[0].order
            self.delegate = secondVC
            DispatchQueue.main.async {
                let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
                self.collectionView.selectItem(at: defaultRow, animated: false, scrollPosition: .bottom)
            }
            setNavigationBar(users[0])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.setNavigationBar(self.users[0])
            })
        }else{
            setNavigationBar(nil)
            
            collectionView.addSubview(titleLabel)
            titleLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        }
        
        collectionView.delegate = self
        
        collectionView.register(ClientInfoCell.self, forCellWithReuseIdentifier: ClientInfoCell.reuseIdentifier)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        let secondtAcOrVC = UINavigationController(rootViewController: secondVC)
        
        let stackView = UIStackView(arrangedSubviews: [collectionView,lineView,secondtAcOrVC.view])
        secondtAcOrVC.view.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0.3
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 350),
        ])
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){
            
            collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClientInfoCell.reuseIdentifier, for: indexPath) as? ClientInfoCell else {fatalError(ClientInfoCell.reuseIdentifier)}
                
                cell.configureCell(item as? User)
                cell.dotView.isHidden = false
                
                let myCustomSelectionColorView = UIView()
                myCustomSelectionColorView.backgroundColor = .quaternaryLabel
                cell.selectedBackgroundView = myCustomSelectionColorView
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.title.text = "completed"
            sectionHeader.requiredAndOptionalButton.setTitle("\(self.users.count) order(s)", for: .normal)
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne])
        
        snapShot.appendItems(users,toSection: .sectionOne)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createClientInfosSection()
            }
        }
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
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .estimated(80))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
    
    func retrieveData(){
        
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = documentDirectory.appendingPathComponent("OrderHistory")
        
        guard let data = try? Data(contentsOf: path) else {return}
        
        guard let jsonData = try? JSONDecoder().decode([User].self, from: data) else {return}
        
        self.users = jsonData
    }
    
    func setNavigationBar( _ user:User?) {
        
        let  navigationBarView = UIView()
        
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)).withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
            button.setTitle(" Order History", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 22,weight: .semibold)
            return button
        }()
        
        let nameLabel: UILabel = {
            let appNameLabel = UILabel()
            appNameLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
            appNameLabel.text = user?.personInfo.getNameInitials()
            return appNameLabel
        }()
        
        let orderNumLabel: UILabel = {
            let label = UILabel()
            label.textColor = .gray
            label.text = user?.orderNum
            return label
        }()
        
        let itemNumlabel: UILabel = {
            let label = UILabel()
            label.textColor = .gray
            label.text = "\(user?.order.orderItem.count ?? 0)"
            return label
        }()
        
        let dotSize = 14
        
        let dotView: CheckBox = {
            let view = CheckBox()
            view.checkedBorderColor = .clear
            view.isChecked = true
            view.checkmarkColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let itemStringlabel: UILabel = {
            let labelOne = UILabel()
            labelOne.textColor = .gray
            labelOne.text = "items"
            return labelOne
        }()
        
        let grandTotalLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 25)
            label.textColor = .systemGreen
            label.text = total
            return label
        }()
        
        let stackViewFour = UIStackView(arrangedSubviews: [orderNumLabel,dotView,itemNumlabel,itemStringlabel])
        stackViewFour.spacing = 3
        
        let stackViewFive = UIStackView(arrangedSubviews: [nameLabel,stackViewFour])
        stackViewFive.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [backButton,stackViewFive])
        stackView.spacing = 180
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBarView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: navigationBarView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: navigationBarView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo:navigationBarView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            dotView.widthAnchor.constraint(equalToConstant: CGFloat(dotSize)),
            dotView.heightAnchor.constraint(equalToConstant: CGFloat(dotSize)),
        ])
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationBarView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: grandTotalLabel)
    }
    
    @objc func backToMain(){
        navigationController?.popToRootViewController(animated: true)
    }
}

extension OrderHistoryContainerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            setNavigationBar(users[indexPath.item])
            
            let selectedUser = users[indexPath.item]
            delegate?.getData(selectedUser.order)
        }
    }
}
