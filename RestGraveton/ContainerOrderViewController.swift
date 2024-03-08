//
//  ContainerOrderViewController.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/21/23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class ContainerOrderViewController: UIViewController {
    
    private let buttonTitle = "See history"
    
    var vc: ViewController?
    var configuration = UIButton.Configuration.plain()
    
    private let secondtAcOrVC = SecondActiveOrderViewController()
    
    var users: [User] = []{
        
        didSet{
            self.reloadData()
        }
    }
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    private var cellItemToTimerMapping: [Int: Timer] = [:]
    private var cellItemToPauseFlagMapping: [Int: Bool] = [:]
    private let fileManager = FileManager.default
    private var isSelectedButton: Bool = false
    private var defaultHighlightedCell: Int = 0
    private var indexPathItem:Int?
    weak var delegate: inputDataDelegate?
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Order ready for pickup", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    let lineView: UILabel = {
        let lineView = UILabel()
        lineView.backgroundColor = .gray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = [User(orderStatus: "client will pick up",orderNum: "O3434b",timestamp: 32.43242,personInfo: PersonInfo(fullName: "Daniel Zhagnay Zamora"),order: Order(orderItem: [OrderItem(name: "Pad Thai",protein: ["chicken"],spiceLevel: "xxx", addItems: ["green one ($12.99)","water chestnut ($12.99)","pea ($12.99)","one ($12.99)","Two ($12.99)","Three ($12.99)","four ($12.99)"], quantity:2,price: 343.44)])),User(orderStatus: "client will pick up",orderNum: "O3434b",timestamp: 32.43242,personInfo: PersonInfo(fullName: "Jesuse zamora lima"),order: Order( orderItem: [OrderItem(name: "Frired Rice",protein: ["chicken"],spiceLevel: "xxx",addItems: ["green one ($12.99)"],quantity: 1,price: 343.44),OrderItem(name: "Drunken Noodle",protein: ["beef"],spiceLevel: "xxx",addItems: ["green one ($12.99)"],quantity: 1,price: 343.44)]))]
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.delegate = self
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(ClientInfoCell.self, forCellWithReuseIdentifier: ClientInfoCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        if let user = users.first {
            setNavigationBar(user)
            secondtAcOrVC.order = user.order
        }else{
            setNavigationBar(nil)
        }
        
        self.delegate = secondtAcOrVC
        
        let navSecondVC = UINavigationController(rootViewController: secondtAcOrVC)
    
        let stackView = UIStackView(arrangedSubviews: [collectionView,lineView,navSecondVC.view])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 330),
            
            lineView.widthAnchor.constraint(equalToConstant: 1),
            floatingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 340),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(backToMain), name: NSNotification.Name("com.user.history"), object: nil)
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){
            
            collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClientInfoCell.reuseIdentifier, for: indexPath) as? ClientInfoCell else {fatalError(ClientInfoCell.reuseIdentifier)}
                
                cell.configureCell(item as? User)
                
                let myCustomSelectionColorView = UIView()
                myCustomSelectionColorView.backgroundColor = .quaternaryLabel
                cell.selectedBackgroundView = myCustomSelectionColorView
                
                self.setupTimer(for: cell, indexPath: indexPath)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError(ButtonCell.reuseIdentifier)}
                
                cell.name.text = item as? String
                cell.name.textColor = .white
                cell.backgroundColor = .quaternaryLabel
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.title.text = "IN THE KITCHEN"
            sectionHeader.requiredAndOptionalButton.setTitle("\(self.users.count) order", for: .normal)
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo])
        
        snapShot.appendItems(users,toSection: .sectionOne)
        snapShot.appendItems([buttonTitle],toSection: .sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createClientInfosSection()
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
    
    @objc func didTapButton(_ sender:UIButton){
        
        if let indexPathItem = indexPathItem {
            
            saveToHistory(users[indexPathItem])
            users.remove(at: indexPathItem)
            
            if users.count == 0 {backToMain()
                return
            }
        }else{
            return
        }
        
        sender.backgroundColor = .systemRed
        sender.setTitle("Marked as ready for pick up", for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            sender.setTitle("Order ready for pickup", for: .normal)
            sender.backgroundColor = .systemBlue
        })
        
        DispatchQueue.main.async {
            let defaultRow = IndexPath(item: self.defaultHighlightedCell, section: 0)
            self.collectionView.selectItem(at: defaultRow, animated: false, scrollPosition: .bottom)
        }
        
        self.reloadData()
    }
    
    func saveToHistory(_ user:User){
        
        storeDueAmount(user)
        
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = documentDirectory.appendingPathComponent("OrderHistory")
        
        guard let data = try? Data(contentsOf: path) else {
            
            var users = [User]()
            users.append(user)
            do{
                let jsonData = try? JSONEncoder().encode(users)
                try? jsonData?.write(to: path)
            }
            return
        }
        
        guard var users = try? JSONDecoder().decode([User].self, from: data) else {return}
        
        users.append(user)
        
        if users.count > 70 {
            
            for _ in 0..<users.count {
                
                users.remove(at: 0)
                
                if users.count == 30 {
                    break
                }
            }
        }
        
        do{
            let encodedUsers = try? JSONEncoder().encode(users)
            try encodedUsers?.write(to: path)
        }catch {}
    }
    
    func storeDueAmount(_ user: User){
        
        let databse = Firestore.firestore()
        let collDocument = databse.collection("Parners").document(CameraManager.shared.stringUID ?? "d")
        
        var total:Double = 0.0
        
        for orderItem in user.order.orderItem {
            
            total += orderItem.price ?? 0.0
        }
        
        collDocument.getDocument { document, error in
            
            if let document = document?.data() {
                
                total += document["amount"] as? Double ?? 0.0
                collDocument.setData(["amount":total],merge: true)
            }
        }
    }
    
    private func setupTimer(for cell: UICollectionViewCell, indexPath: IndexPath) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        
        let item = indexPath.item
        
        if cellItemToTimerMapping[item] == nil {
            
            var numberOfSecondsPassed = 10
            
            let timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { capturedTimer in
                
                if self.cellItemToPauseFlagMapping[item] != nil && self.cellItemToPauseFlagMapping[item] == true {return}
                
                numberOfSecondsPassed -= 1
                
                let visibleCell = cell as? ClientInfoCell
                
                if let visibleCell = visibleCell {
                    visibleCell.readyPickUpLabel.text = "\(String(numberOfSecondsPassed))"
                }
                
                if numberOfSecondsPassed == 0 {
                    
                    numberOfSecondsPassed = 10
                    self.cellItemToPauseFlagMapping[item] = true
                    if let visibleCell = visibleCell {
                        
                        let date = dateFormatter.string(from: Date())
                        visibleCell.readyPickUpLabel.text = date
                    }
                    self.makeNetworkCall {
                        self.cellItemToPauseFlagMapping[item] = true
                    }
                }
            }
            
            cellItemToTimerMapping[item] = timer
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func makeNetworkCall(completion: @escaping (() -> ())) {
        
        let seconds = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func setNavigationBar(_ user:User?) {
        
        let navigationBarView = UIView()
        
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)).withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
            return button
        }()
        
        let labelOne: UILabel = {
            let labelOne = UILabel()
            labelOne.text = "orders"
            labelOne.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            return labelOne
        }()
        
        let customAcceptingOrderView = CustomAcceptingOrderView()
        
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
        
        let printerButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "printer",withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(didTapPrintButton), for: .touchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 3
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            return button
        }()
        
        let issueWithOrderButton: UIButton = {
            let button = UIButton()
            button.setTitle("Issue with Order", for: .normal)
            button.addTarget(self, action: #selector(didTapIssueWithOrderButton), for: .touchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 3
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            return button
        }()
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top:0, leading:10, bottom:0, trailing:10)
        printerButton.configuration = configuration
        issueWithOrderButton.configuration = configuration
        
        let stackViewOne = UIStackView(arrangedSubviews: [backButton,labelOne])
        stackViewOne.spacing = 20
        
        let stackViewTwo = UIStackView(arrangedSubviews: [stackViewOne,customAcceptingOrderView])
        stackViewTwo.spacing = 100
        
        let stackViewFour = UIStackView(arrangedSubviews: [orderNumLabel,dotView,itemNumlabel,itemStringlabel])
        stackViewFour.spacing = 2
        
        let stackViewFive = UIStackView(arrangedSubviews: [nameLabel,stackViewFour])
        stackViewFive.axis = .vertical
        
        let stackViewSix = UIStackView(arrangedSubviews: [printerButton,issueWithOrderButton])
        stackViewSix.spacing = 20
        
        let stackView = UIStackView(arrangedSubviews: [stackViewTwo,stackViewFive])
        stackView.spacing = 30
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackViewSix)
    }
    
    @objc func didTapPrintButton(){
        share(text: "Daniel")
    }
    
    @objc func didTapIssueWithOrderButton(){
        let alertController = UIAlertController(title: "what is the issue?", message: "to report issue type", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "report", style: .default) { _ in
            
            //let inputName = alertController.textFields![0].text
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func share(text: String) {
        
        let str = NSAttributedString(string: text)
        let print = UISimpleTextPrintFormatter(attributedText: str)
        
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: [textToShare,print], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [.airDrop,.markupAsPDF]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func backToMain(){
        
        navigationController?.popToRootViewController(animated: true)
        vc?.hasOrderNot(users.count)
    }
}

extension ContainerOrderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            self.indexPathItem = indexPath.item
            
            let selectedUser = users[indexPath.item]
            setNavigationBar(selectedUser)
            delegate?.getData(selectedUser.order)
        }
        
        if indexPath.section == 1 {
            navigationController?.popToRootViewController(animated: true)
            vc?.testingFunction()
            vc?.hasOrderNot(users.count)
        }
    }
}
